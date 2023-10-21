

/*
    Click
        Like
        Report
    
    Text
        Comment

*/


console.log("ready");

setTimeout(() => {
  let self = this;
  let isLoggedIn = false;

  let loginInterval;

  loginInterval = setInterval(() => {
    if (document.querySelector("[data-testid=mobile-nav-logged-in]") == undefined) {
      isLoggedIn = false;
    } else {
      isLoggedIn = true;
      clearInterval(loginInterval);
    }
  }, 300);

  let loop_like = setInterval(() => {
    let like = document.querySelector("[aria-label=Like]");
    if (!like) {
    } else {
      console.log("found like");
      clearInterval(loop_like);
      sendMessage("current.like", false);
      like.closest("button").onclick = () => {
        sendMessage("click", "like");
      };
    }
  });

  let loop_unlike = setInterval(() => {
    let unlike = document.querySelector("[aria-label=Unlike]");
    if (!unlike) {
    } else {
      console.log("found unlike");
      clearInterval(loop_unlike);
      sendMessage("current.like", true);
      unlike.closest("button").onclick = () => {
        sendMessage("click", "like");
      };
    }
  });

  let loop_comment = setInterval(() => {
    let textarea = document.querySelector("textarea[data-testid=post-comment-text-area]");
    if (!textarea) {
    } else {
      console.log("found textarea");
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
  });

  let loop_post = setInterval(() => {
    let form = document.getElementsByTagName("form")[0];
    if (!form) {
    } else {
      console.log("found form");
      clearInterval(loop_post);
      form.onsubmit = () => {
        sendMessage("click", "post");
      };
    }
  });

  document.addEventListener("click", function (e) {
    if (isLoggedIn && e.target.textContent.trim().toLowerCase() == "report") {
      sendMessage("click", "report");
    }
  });

  function sendMessage(action, message) {
    window.flutter_inappwebview.callHandler("handler", action, message);
  }

}, 500);
