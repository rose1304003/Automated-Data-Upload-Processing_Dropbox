package com.ishc.portal.client.exec;

import com.common.*;
import com.frame.DBLayer;
import com.frame.MySystemInfo;
import com.ishc.portal.client.ISHCPortalClient;
import com.ishc.portal.client.ISHCPortalClientClassLoader;
import com.ishc.portal.client.exec.export.ExportImagesCommandLineParser;
import com.ishc.portal.client.exec.export.XMLExportImagesConfiguration;
import com.ishc.portal.client.exec.ui.components.ImageExportUserSelectorDialog;
import com.ishc.portal.client.util.Logger;
import org.apache.commons.configuration.XMLConfiguration;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class ExportImages
{
    //
    //            Level 2         ---   Level 3    --- Level 4
    // to be filed special folder --- doctor name  --- patient name
    // patients special folder    --- patient name --- folder name
    //
    private static final int MAX_LEVELS = 4;

    private static final String OVERFLOW_BIN_NAME = "BULK_EXPORT";

    private static String safePath(String basePath, String path)
    {
        // figure out relative (to base) path
        int basePathLength = basePath.length();
        String subPath = path.substring(basePathLength);
        if(subPath.length() == 0)
        {
            return path;
        }

        // handle long paths - place those into overflow bin
        String [] pathElements = subPath.split("/");
        int numElements = pathElements.length;
        if(numElements > MAX_LEVELS)
        {
            String firstElement = pathElements[1];
            String lastElement = pathElements[numElements - 1];
            path = basePath + "/" + firstElement + "/" + OVERFLOW_BIN_NAME + "/" + lastElement;
        }
        
        return path;
    }

    private static String normalize(String name)
    {
        String normalized = name.replaceAll("[.:/\\\\]","_").replaceAll("[\\*\\?\"|<>]"," ").trim();
        return normalized;
    }

    private static final String getBasePath(String path, VirtualFolder folder)
    {
        path += "/" + normalize(folder._name);
        path += " (" + folder._guid + ")";
        return path;
    }

    private static void exportImages(VirtualFolder virtualFolder, String path, String basePath) throws Exception
    {
        path += "/" + normalize(virtualFolder._name);
        path += " ("+virtualFolder._guid+")";
        path = safePath(basePath, path);
        File dir = new File(path);
        if(dir.exists())
        {
            if(dir.isDirectory())
            {
                if(!dir.canWrite())
                {
                    throw new IOException("Unable to write to target folder " + path);
                }
                Logger.log("TARGET FOLDER " + path + " ALREADY EXISTS");
            }
            else
            {
                throw new IOException("Target folder " + path + " is not a directory");
            }
        }
        else 
        {
            if(!dir.mkdirs())
            {
                throw new IOException("Unable to create folder: " + path);
            }
        }

        Logger.log("LOADING IMAGES FOR FOLDER " + virtualFolder._name + " (" + virtualFolder._guid + ")");

        virtualFolder.LoadImages(null, false);

        if(virtualFolder._imgs.size() > 0)
        {
            int indx;
            Map fmap = new HashMap();
            Logger.log("LOADING FILE LIST FOR EXPORT PATH " + dir.getAbsolutePath());
            File[] files = dir.listFiles();
            String  fname;
            for(int i = 0; i < files.length; i++)
            {
                if(files[i].isFile())
                {
                    fname = files[i].getName();
                    indx = fname.lastIndexOf('.');
                    if(indx > 0)
                    {
                        fname = fname.substring(0, indx)+fname.substring(indx).toLowerCase();
                    }
                    fmap.put(fname, "1");
                }
            }

            ViewImage vimg;
            String name, fullname;
            for(int i = 0; i < virtualFolder._imgs.size(); i++)
            {
                vimg = (ViewImage)virtualFolder._imgs.elementAt(i);
                name = vimg._img._name;
                indx = name.lastIndexOf('.');
                if (indx > 0)
                {
                    name = name.substring(0, indx);
                }
                name = normalize(name);
                name += " ("+vimg._iguid+")";
                if(!fmap.containsKey(name+"."+vimg._img._type.toLowerCase()))
                {
                    String exportFileName = path + "/" + name;
                    String exportFileExtension = normalize(vimg._img._type.toLowerCase());
                    Logger.log("EXPORTING IMAGE " + vimg._iguid + " TO " + exportFileName + "." + exportFileExtension);
                    fullname =
                            TTLImage.WriteToExportFile(".", vimg._iguid, exportFileName, exportFileExtension, false);
                    Logger.log("IMAGE " + vimg._iguid + " SAVED TO " + fullname);
                    // setting Create and Modified times from EXIF info
                    long exiftime = vimg._img._exifdate.getTime();
                    // don't set file times to reflect exif information
                    //FileTimes.setFileTimes(fullname, exiftime, new Date().getTime(), exiftime);
                }
                else
                {
                    Logger.log("SKIPPING IMAGE " + vimg._iguid);
                }
            }
            virtualFolder.ClearImages();
        }

        VirtualFolder child;
        for (int i = 0; i < virtualFolder._child.size(); i++) {
            child = (VirtualFolder)virtualFolder._child.elementAt(i);
            exportImages(child, path, basePath);
        }
    }

    private static void exportImages(TTLUser user, String path) throws Exception
    {
        UserAccount acct = UserAccount.GetFromGUID(null, user._acct_guid, false);
        if(acct == null)
        {
            throw new Exception("User account " + user._acct_guid + " not found");
        }

        File dir = new File (path);
        dir.mkdir();
        if(dir.exists() && dir.isDirectory())
        {
            dir.mkdir();
            FolderTree folderTree = new FolderTree(user._acct_guid, user._guid);
            folderTree.Rebuild(acct, user, null, false);
            VirtualFolder rootFolder;
            for(int i = 0; i < folderTree._roots.size(); i++)
            {
                rootFolder = (VirtualFolder)folderTree._roots.elementAt(i);
                // do not export images shared with this user
                if(rootFolder._type == VirtualFolder.TYPE_SHARED)
                {
                    Logger.log("SKIPPING SHARED FOLDER " + rootFolder._name + " (" + rootFolder._guid + ")");
                    continue;
                }
                String basePath = getBasePath(path, rootFolder);
                exportImages(rootFolder, path, basePath);
            }
        }
        else
        {
            throw new IOException("Export path " + path + " does not exist or is not a directory");
        }
    }

    public static void main(String [] args) throws Exception
    {
        ISHCPortalClientClassLoader.init();

        ExportImagesCommandLineParser cmdLine = new ExportImagesCommandLineParser(args);
        cmdLine.parse();
        if(cmdLine.help(false))
        {
            System.exit(1);
        }

        XMLConfiguration xmlConfiguration = cmdLine.getXmlConfiguration();

        ISHCPortalClient.initLogging(xmlConfiguration);

        Logger.log("CONFIGURING CLASSPATH...");
        int fileIdx = 1;
        for(String file : ISHCPortalClientClassLoader.getClassPath())
        {
            Logger.log(Logger.formatNumber(fileIdx, 3) + ": [" + file + "]");
            fileIdx++;
        }

        Logger.log("STARTING ISHC CLIENT (VERSION " + ISHCPortalClient.getVersion() +
                ", HASH " + ISHCPortalClient.getCommitId() + ")");

        XMLExportImagesConfiguration exportImagesConfiguration =
                new XMLExportImagesConfiguration(xmlConfiguration);

        if(exportImagesConfiguration.isDefaultAuthenticationMode())
        {
            DBLayer.useDefaultAuthentication();
        }
        else if(exportImagesConfiguration.isNetworkAuthenticationMode())
        {
            // since the user selector needs to query the database, we should set database
            // connection information before user selector is called
            DBLayer._host = exportImagesConfiguration.getDatabaseAddress();
            DBLayer._port = exportImagesConfiguration.getDatabasePort();
            DBLayer.setDbLogin(exportImagesConfiguration.getDatabaseUser());
            DBLayer.setDbPassword(exportImagesConfiguration.getDatabasePassword());

            if(!exportImagesConfiguration.isAccountIdSet() || !exportImagesConfiguration.isDestinationFolderSet())
            {
                Logger.log("DATABASE CONNECTION INFORMATION:");
                Logger.log("  SERVER:     " + exportImagesConfiguration.getDatabaseAddress());
                Logger.log("  PORT:       " + exportImagesConfiguration.getDatabasePort());
                Logger.log("  CLUSTER ID: " + exportImagesConfiguration.getClusterID());
                Logger.log("  SERVER ID:  " + exportImagesConfiguration.getServerID());
                Logger.log("INITIALIZING REMOTE DATA CONNECTION...");
                // we are going to have to decrypt user login, so we need perform partial system initialization
                MySystemInfo.Init(exportImagesConfiguration.getClusterID(), exportImagesConfiguration.getServerID());
                Logger.log("REMOTE DATA CONNECTION INITIALIZED");

                ImageExportUserSelectorDialog userSelector =
                        ImageExportUserSelectorDialog.showDialog(exportImagesConfiguration);
                if(userSelector.getSelectedAccountID() == null)
                {
                    Logger.log("ACCOUNT ID NOT SELECTED");
                    System.exit(1);
                }
                if(userSelector.getExportPath() == null)
                {
                    Logger.log("EXPORT PATH NOT SELECTED");
                    System.exit(2);
                }

                // if user account is selected, set it into configuration
                exportImagesConfiguration.setAccountId(userSelector.getSelectedAccountID());
                exportImagesConfiguration.setDestinationFolderPath(userSelector.getExportPath());
            }
        }

        String path = exportImagesConfiguration.getDestinationFolderPath();
        String accountId = exportImagesConfiguration.getAccountId();

        Logger.log("ACCOUNT ID SELECTED: " + accountId);

        TTLUser user = TTLUser.LoadFromGUID(accountId, false);
        if(user == null)
        {
            throw new Exception("User " + accountId + " not found");
        }

        user.BuildFullName();
        Logger.log("EXPORTING IMAGES FROM USER ACCOUNT: " + user._name);
        Logger.log("SAVING IMAGES TO: " + path);

        exportImages(user, path);

        // the application will stay active if there's a UI thread, so exit explicitly here
        System.exit(0);
    }
}
