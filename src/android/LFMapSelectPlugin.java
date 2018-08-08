package com.lnsoft.cordovaPlugins;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;

/**
 * This class echoes a string called from JavaScript.
 */
public class LFMapSelectPlugin extends CordovaPlugin {

    private static final String Baidu="com.baidu.BaiduMap";
    private static final String Gaode="com.autonavi.minimap";
    private static final String Tengxun="com.tencent.map";
    
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("showSheetViewWithModel")) {
            ArrayList<String> mapApps = mapApps(cordova.getActivity());
            String[] maps = new String[mapApps.size()];
            for (int i = 0; i < mapApps.size(); i++) {
                maps[i] = getAppName(mapApps.get(i));
            }
            JSONObject jsonObject = args.getJSONObject(0);
            String latitude = jsonObject.getString("latitude");
            String longitude = jsonObject.getString("longitude");
            String cityName = jsonObject.getString("cityName");
            AlertDialog dialog;
            if (mapApps.size() == 0) {
                dialog = new AlertDialog.Builder(cordova.getActivity()).setMessage("未在您的手机上发现地图软件")
                        .setPositiveButton("知道了", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                            }
                        }).create();
            } else if (mapApps.size() == 1) {
                dialog = new AlertDialog.Builder(cordova.getActivity()).setMessage("是否打开" + getAppName(mapApps.get(0)) + "?")
                            .setNegativeButton("取消", null).setPositiveButton("确定", new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    switch (mapApps.get(0)) {
                                        case Baidu:
                                            toBdMapApp(latitude, longitude, cityName);
                                            break;
                                        case Gaode:
                                            toGaodeApp(latitude, longitude, cityName);
                                            break;
                                        default:
                                            break;
                                    }
                                    dialog.dismiss();
                                }
                            }).create();
                } else {
                    dialog = new AlertDialog.Builder(cordova.getActivity()).setTitle("请选择地图软件")
                            .setItems(maps, new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    switch (maps[which]) {
                                        case "百度地图":
                                            toBdMapApp(latitude, longitude, cityName);
                                            break;
                                        case "高德地图":
                                            toGaodeApp(latitude, longitude, cityName);
                                            break;
                                        case "腾讯地图":
                                            toTengxunApp(latitude,longitude,cityName);
                                            break;
                                        default:
                                            break;
                                    }
                                    dialog.dismiss();
                                }
                            }).create();
                }
                dialog.show();
            
            return true;
        }
        return false;
    }
 public static ArrayList<String> mapApps(Context context) {
        final PackageManager packageManager = context.getPackageManager();
        List<PackageInfo> packageInfos = packageManager.getInstalledPackages(0);
        ArrayList<String> packageNames = new ArrayList<String>();
        if (packageInfos != null) {
            for (int i = 0; i < packageInfos.size(); i++) {
                String packName = packageInfos.get(i).packageName;
                if (packName.equals(Gaode) || packName.equals(Baidu)||packName.equals(Tengxun)) {
                    packageNames.add(packName);
                }
            }
        }
        return packageNames;
    }

    public String getAppName(String packageName) {
        if (Baidu.equals(packageName)) {
            return "百度地图";
        }
        if (Gaode.equals(packageName)) {
            return "高德地图";
        }
        if (Tengxun.equals(packageName)) {
            return "腾讯地图";
        }
        return "";
    }

    public void toBdMapApp(String latitude, String longitude, String cityName) {
        try {
            Intent intent = Intent.parseUri("baidumap://map/direction?destination=name:" + cityName + "|latlng:" + latitude + "," + longitude + "&", 0);
            cordova.getActivity().startActivity(intent);
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
    }

    public void toGaodeApp(String latitude, String longitude, String cityName) {
        try {
            Intent intent = Intent.parseUri("amapuri://route/plan/?dlat=" + latitude + "&dlon=" + longitude + "&dname=" + cityName + "&dev=0&t=0", 0);
            cordova.getActivity().startActivity(intent);
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
    }

    public void toTengxunApp(String latitude,String longitude,String cityName){
        try {
            Intent intent = Intent.parseUri("qqmap://map/routeplan?type=drive&to=" + cityName + "&tocoord=" + latitude+ "," +longitude  + "&referer=myapp",0);
            cordova.getActivity().startActivity(intent);
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
    }
}
