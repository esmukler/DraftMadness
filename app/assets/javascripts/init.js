(function() {

    var triggerEvents = function(body) {
        var pageID = body.attr('class');
        pageID = pageID.replace(' ', ':')

        body.trigger(pageID);
    };

    var init = function() {
        var body = $('body');

        if (body.length) {
            window.dm = window.dm || {};

            triggerEvents(body);
        } else {
            setTimeout(init, 100);
        }
    };

    init();
})();
