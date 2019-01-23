'use strict';

/**
 * Redirects URLs to default document. Examples:
 *
 * /blog            -> /blog/index.html
 * /blog/july/      -> /blog/july/index.html
 * /blog/header.png -> /blog/header.png
 * https://stackoverflow.com/questions/31017105/how-do-you-set-a-default-root-object-for-subdirectories-for-a-statically-hosted
 */

let defaultDocument = 'index.html';

exports.handler = (event, context, callback) => {
    const request = event.Records[0].cf.request;
    const headers     = request.headers;
    const host = headers['host'][0].value;
    if(host.startsWith('www.')){
        const location = "https://" + host.replace("www.", "") + request.uri;
        const response = {
            status: '302',
            statusDescription: 'Found',
            headers: {
                location: [{
                    key: 'Location',
                    value: location
                }]
            }
        };
        callback(null, response);
    } else {
        if(request.uri != "/") {
            let paths = request.uri.split('/');
            let lastPath = paths[paths.length - 1];
            let isFile = lastPath.split('.').length > 1;

            if(!isFile) {
                if(lastPath != "") {
                    request.uri += "/";
                }

                request.uri += defaultDocument;
            }

            console.log(request.uri);
        }

        callback(null, request);
    }
};
