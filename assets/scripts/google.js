window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
    console.log("ready");

    let loop = setInterval(() => {
        var iframe = document.getElementsByName('goog-reviews-write-widget')[0];
        if (iframe == undefined) {
            console.log('not found container');
        } else {
            var iframe_doc = iframe.contentDocument;
            clearInterval(loop);
            

            let loop_stars = setInterval(() => {
                let rating_container = iframe_doc.getElementsByClassName('rating')[1];
                if (rating_container == undefined) {
                    console.log('not found rating');
                } else {
                    clearInterval(loop_stars);
                    let rating_buttons = rating_container.children;
                    Array.prototype.slice.call(rating_buttons).forEach((r, i) => {
                        r.onclick = () => {
                            sendMessage('click', 'star.' + i);
                        }
                    })
                }
            })

            let loop_comment = setInterval(() => {
                    let textarea = iframe_doc.getElementsByTagName('textarea')[0];
                    if (textarea == undefined) {
                        console.log('not found textarea');
                    } else {
                        clearInterval(loop_comment);
                        console.log('Found textarea');
                        textarea.oninput = () => {
                            sendMessage('text', textarea.value)
                        }
                    }
            }, 100)


            let loop_post = setInterval(() => {
                let post = iframe_doc.getElementsByClassName('quantum-button-flat-text')[0];
                if (post == undefined) {
                    console.log('not found post');
                } else {
                    clearInterval(loop_post);
                    console.log('Found post');
                    post.onclick = () => {
                        sendMessage('click', 'post');
                    }
                }
        }, 100)
        }

    }, 1000);


  });
function sendMessage(action, message) {
    window.flutter_inappwebview.callHandler('handler', action, message)
}