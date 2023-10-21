var inCommentFlow = false;
document.addEventListener("keydown", function() {
    if(! inCommentFlow)
        startCommentFlow();
    
    return;
});

document.addEventListener('click', function (e) {
    let element = e.target;
    let text = element.innerText.toLowerCase().trim();
    console.log("Main click event");
    console.log(element);
    console.log(text);
    if (text == null || text.length > 60)
        return;

    const op = getOp(text);
    if (op != false) {
        console.log("Op: " + op);
        switch (op) {
            case 'like':
                sendMessage('click', 'like');
                break;

            case 'comment':
                startCommentFlow();
                break;

            case 'report':
                sendMessage('click', 'report')
                break;

            case 'share':
                sendMessage('click', 'share');
                break;
        }
    } else {
        console.log("New design");
        // New design

        if(element.tagName.toLowerCase() == "textarea") {
            console.log("comment detected");
                startCommentFlow();
            return;
        }

        let actionElement = element.closest("[data-action-id]");
        if(actionElement) {
            let actionsBar = actionElement.parentNode;
            let availableActions = actionsBar.children;
            if(availableActions.length == 3) {
                console.log("Found 3 actions");
                let likeActionId = availableActions[0].getAttribute("data-action-id");
                let commentActionId = availableActions[1].getAttribute("data-action-id");
                let shareActionId = availableActions[2].getAttribute("data-action-id");

                let currentActionId = actionElement.getAttribute("data-action-id");
                if(currentActionId == likeActionId) {
                    console.log("Like detected");
                    sendMessage("click", "like");
                    return;
                } else if(currentActionId == commentActionId) {
                    console.log("comment detected");
                    startCommentFlow();
                    return;
                } else if(currentActionId == shareActionId) {
                    console.log("share detected");
                    sendMessage("click", "share");
                    return;
                }
            }
        }
    }
});

function getOp(text) {
    /**
     * op: [keywords]
     */
    const ops = {
        'like': ['like', 'לייק'],
        'comment': ['comment', 'תגובה'],
        'report': ['report', 'דווח', 'דיווח'],
        'share': ['share', 'שיתוף', 'שתף', 'שתפי']
    };

    console.log("Text: " + text);
    for (const op in ops) {
        let keywords = ops[op];
        for (const keyword of keywords) {
            if (text.includes(keyword)) {
                return op;
            }
        }
    }

    return false;
}

function startCommentFlow() {
    console.log("Starting comment flow");
    let commentValue = "";
    inCommentFlow = true;

    // Reset
    removeHandlers();

    registerHandlers();

    function clickHandler(e) {
        finalize();
    }

    function inputHandler(e) {
        commentValue = e.target.value.trim();
    }

    function keydownHandler(e) {
        if (e.keyCode == 13) {
            finalize();
        }
    }

    function registerHandlers() {
        document.addEventListener("click", clickHandler);
        document.addEventListener("input", inputHandler);
        document.addEventListener("keydown", keydownHandler);
    }

    function removeHandlers() {
        document.removeEventListener("click", clickHandler);
        document.removeEventListener("input", inputHandler);
        document.removeEventListener("keydown", keydownHandler);
    }

    function finalize(withMessage = true) {
        inCommentFlow = false;
        console.log("Finalizing comment flow with value: " + commentValue);
        removeHandlers();
        if (withMessage)
            sendMessage('click', 'comment.' + commentValue);
    }
}

function sendMessage(action, message) {
    window.flutter_inappwebview.callHandler('handler', action, message)
}