/**
 * LIKE, DISLIKE, SHARE
 */

let topButtonsContainerInterval = setInterval(function() {
    let topButtonsContainer = document.querySelector(".slim-video-action-bar-actions");
    if(!! topButtonsContainer) {
        console.log("Found .slim-video-action-bar-actions");
        clearInterval(topButtonsContainerInterval);

        let buttons = topButtonsContainer.querySelectorAll("button");

        let likeButton = buttons[0];
        let dislikeButton = buttons[1];
        let shareButton = buttons[2];
        let reportButton = buttons[4]

        likeButton.addEventListener("click", function(){
            sendMessage("click", "like");
        });

        dislikeButton.addEventListener("click", function() {
            sendMessage("click", "dislike");
        });

        shareButton.addEventListener("click", function() {
            sendMessage("click", "share");
        });

        reportButton.addEventListener("click", function() {
            sendMessage("click", "report");
        });
    }
}, 250);

/**
 * COMMENT
 */
let commentButtonInterval = setInterval(function() {
    let commentTextarea = document.querySelector("textarea.comment-simplebox-reply");
    if(!! commentTextarea) {
        console.log("Found comment dialog");
        clearInterval(commentButtonInterval);

        let commentButton = commentTextarea.parentNode.querySelectorAll("button")[1];

        commentButton.addEventListener("click", function() {
            let comment = commentTextarea.value;
            sendMessage("click", "comment."+comment);
        });
    }
}, 250);

function sendMessage(action, message) {
    console.log("action: "+action, "message: "+message);
    window.flutter_inappwebview.callHandler('handler', action, message)
}