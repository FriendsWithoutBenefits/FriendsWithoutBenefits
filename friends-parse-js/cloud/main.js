var fs = require('fs');
var layer = require('cloud/layer-parse-module/layer-module.js');
var layerProviderID = 'layer:///providers/5f221632-29fd-11e5-b1f9-94a8000000fb';  // Should have the format of layer:///providers/<GUID>
var layerKeyID = 'layer:///keys/b9c902b8-5e7c-11e5-bfeb-48db37005699';   // Should have the format of layer:///keys/<GUID>
var privateKey = fs.readFileSync('cloud/layer-parse-module/keys/layer-key.js');
layer.initialize(layerProviderID, layerKeyID, privateKey);
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("generateToken", function(request, response) {
    var currentUser = request.user;
    if (!currentUser) throw new Error('You need to be logged in!');
    var userID = currentUser.id;
    var nonce = request.params.nonce;
    if (!nonce) throw new Error('Missing nonce parameter');
        response.success(layer.layerIdentityToken(userID, nonce));
});