# cordova-plugin-lnsoft-lfmapselect

该插件用来唤醒手机原生地图应用，实现导航功能。在 `deviceready` 事件完成后，调用 `navigator.lnsoft.callNativeMapApp`
方法即可。

```js
document.addEventListener('deviceready', onDeviceReady, false);
function onDeviceReady() {
    navigator.lnsoft.callNativeMapApp(successCallback, errorCallback, [
        {"cityName": "广州塔", "longitude": "113.3245904", "latitude": "23.1066805"}
    ]);
}
function successCallback() {
    // ...
}
function errorCallback() {
    // ...
}
```

## 安装

    cordova plugin add cordova-plugin-lnsoft-lfmapselect

### 支持的平台

- Android
- iOS