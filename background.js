chrome.runtime.onInstalled.addListener(function() {
    const menu = chrome.contextMenus.create({
        contexts: ["all"],
        type: "normal",
        id: "my_open_in_chrome",
        title: "My open in Chrome"
    });
});

chrome.contextMenus.onClicked.addListener(function(item){
    console.log("open context menu, item:", item);
    let command = '';
    if (item.menuItemId === 'my_open_in_chrome') {
        if (item.linkUrl) {
            command = `open_chrome=${item.linkUrl}`;
        }
        else if (item.pageUrl) {
            command = `open_chrome=${item.pageUrl}`;
        }
    }

    if (command) {
        url = `http://localhost/Temporary_Listen_Addresses/command?${command}`;
        fetch(url)
        .then((res) => {
            console.log('res', res)
        })
        .catch((err) => {
          console.log("err", err);
        });
    }
});
