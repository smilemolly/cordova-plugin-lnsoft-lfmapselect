var exec = require('cordova/exec');

function LFMapSelectPlugin() {
}

LFMapSelectPlugin.prototype.callNativeMapApp = function (successCallback, errorCallback, option) {
    exec(successCallback, errorCallback, 'LFMapSelectPlugin', 'showSheetViewWithModel', option);
};

module.exports = new LFMapSelectPlugin();
