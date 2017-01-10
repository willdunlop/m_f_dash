function parseURL(url) {
        var a =  document.createElement('a');
        a.href = url;
        return {
            source: url,
            protocol: a.protocol.replace(':',''),
            host: a.hostname,
            port: a.port,
            query: a.search,
            params: (function(){
                var ret = {},
                    seg = a.search.replace(/^\?/,'').split('&'),
                    len = seg.length, i = 0, s;
                for (;i<len;i++) {
                    if (!seg[i]) { continue; }
                    s = seg[i].split('=');
                    ret[s[0]] = s[1];
                }
                return ret;
            })(),
            file: (a.pathname.match(/\/([^\/?#]+)$/i) || [,''])[1],
            hash: a.hash.replace('#',''),
            path: a.pathname.replace(/^([^\/])/,'/$1'),
            relative: (a.href.match(/tps?:\/\/[^\/]+(.+)/) || [,''])[1],
            segments: a.pathname.replace(/^\//,'').split('/')
        };
    }


$.fn.serializeObject = function() {
        var o = {"auth_token": "NEW_TOKEN"};
        var a = this.serializeArray();
        $.each(a, function() {
            if (o[this.name] !== undefined) {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });
        return o;
    };

// cf. http://stackoverflow.com/questions/7193238/wait-until-a-condition-is-true
function waitFor(test, expectedValue, msec, count, source, callback) {
    while ( test !== expectedValue ) {
        count ++;
        setTimeout(function() {
            waitFor(test, expectedValue, msec, count, source, callback);
        }, msec);
        return;
    }
    alert(source + ': ' + test() + ', expected: ' + expectedValue + ', ' + count + ' loops.');
    callback();
}

function allWidgetsLoaded() {
    var expectedWidgetCount = $('.gridster ul:first > li').length;
    var loadedWidgetCount = $('.widget').length;
    return expectedWidgetCount === loadedWidgetCount;
}

var editWidgets = {
    onReady: function() {
    $('.icon-background').remove();
    $('.widget-instadash').remove();
    $('.widget-plum').remove();
    $('.widget-image').remove();
    $('.widget-clock').remove();
    $('.widget-forecast').remove();
    $('.gridster ul:first').gridster().data('gridster').disable();
    $('#saving-instructions').remove();

    $('.widget-text').after('<form>Title:<input type="text" name="title" value="">' +
        '1:<input type="text" name="text" value="">' +
        '2:<input type="text1" name="text1" value="">' +
        '3:<input type="text2" name="text2" value="">' +
        '4:<input type="text3" name="text3" value="">' +
        '5:<input type="text4" name="text4" value="">' +
        'More Info:<input type="text" name="moreinfo" value="">' +
        '<br><input type="submit" value="Update"></form>');
    //
    // $('.widget-iframe').after('<form>URL:<input type="text" name="url" value="">' +
    //     '<br><input type="submit" value="Update"></form>');
    //
    // $('.widget-big-image').after('<form>Image URL:<input type="text" name="image" value="">' +
    //     '<br><input type="submit" value="Update"></form>');
    //
    // $('.widget-comments').after('<form>Title:<input type="text" name="title" value="">' +
    //     'More Info:<input type="text" name="moreinfo" value="">' +
    //     '<br><input type="submit" value="Update"></form>');
    //
    // $('.widget-graph').after('<form>Title:<input type="text" name="title" value="">' +
    //     'Value:<input type="text" name="value" value="">' +
    //     'More Info:<input type="text" name="moreinfo" value="">' +
    //     '<br><input type="submit" value="Update"></form>');
    //
    $('.widget-list').after(
        '<form><input placeholder="Goal 1" type="text" name="goal1" data-bind="item.label">' +
          '<input placeholder="Goal 3" name="item.label1" data-bind="item.label1">' +
          '<br><input type="submit"></form>');

    // $('.widget-meter').after('<form>Title:<input type="text" name="title" value="">' +
    //     'Value:<input type="text" name="value" value="">' +
    //     'More Info:<input type="text" name="moreinfo" value="">' +
    //     '<br><input type="submit" value="Update"></form>');
    //
    // $('.widget-number').after('<form>Title:<input type="text" name="title" value="">' +
    //     'Value:<input type="text" name="value" value="">' +
    //     'More Info:<input type="text" name="moreinfo" value="">' +
    //     '<br><input type="submit" value="Update"></form>');

    $('form').submit(function() {
        event.preventDefault();
        var formjson = JSON.stringify($(this).serializeObject());
        var url = parseURL(location.href);
        var widgetid = $(this).prev().data();
        var widgeturl = url.protocol + '://' + url.host + ':' + url.port + '/widgets/' + widgetid.id;
        var method = 'POST';
        var async = true;
        var request = new XMLHttpRequest();
        request.open(method, widgeturl, async);
        request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        request.send(formjson);
        event.preventDefault();
        });
    }
};
