console.log("ready");

let loop_like = setInterval(() => {
    let like = document.querySelector("[data-testid='like']");
    if (!like) {
    } else {
        console.log('found like');
        clearInterval(loop_like);
        like.addEventListener("click", function () {
            sendMessage('click', 'like');
        })
    }
}, 100)


let loop_retweet = setInterval(() => {
    let retweet = document.querySelector("[data-testid='retweet']");
    if (!retweet) {
    } else {
        console.log('found retweet');
        clearInterval(loop_retweet);
        retweet.addEventListener("click", function () {
            console.log("retweet");
            sendMessage('click', 'retweet');
        });
    }
}, 100)

document.addEventListener("keydown", function (e) {
    let target = e.target;
    console.log("event keyup, input");
    if (target.closest("label[data-testid='tweetTextarea_0_label']")) {
        sendMessage('click', "comment." + target.value);
    }
});

let loop_comment = setInterval(() => {
    let textarea = document.querySelector("label[data-testid='tweetTextarea_0_label'] textarea");
    if (!textarea) {
    } else {
        console.log('found textarea');
        clearInterval(loop_comment);
        textarea.addEventListener("change", function () {
            sendMessage('click', "comment." + textarea.value);
        });

        textarea.addEventListener("keydown", function () {
            sendMessage('click', "comment." + textarea.value);
        });

        textarea.addEventListener("input", function () {
            sendMessage('click', "comment." + textarea.value);
        });
    }
}, 100)

let loop_report = setInterval(() => {
    let report = document.querySelector("[data-testid='report']")
    if (!report) {
    } else {
        console.log('found report');
        clearInterval(loop_report);
        report.addEventListener("click", function () {
            sendMessage('click', 'report');
        });
    }
}, 100)



function sendMessage(action, message) {
    window.flutter_inappwebview.callHandler('handler', action, message)
}