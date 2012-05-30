/*
 * QUnit - A JavaScript Unit Testing Framework
 *
 * http://docs.jquery.com/QUnit
 *
 * Copyright (c) 2009 John Resig, Jörn Zaefferer
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 */


(function(window) {

var QUnit = {

  // call on start of module test to prepend name to all tests
  module: function(name, testEnvironment) {
    config.currentModule = name;

    synchronize(function() {
      if ( config.currentModule ) {
        QUnit.moduleDone( config.currentModule, config.moduleStats.bad, config.moduleStats.all );
      }

      config.currentModule = name;
      config.moduleTestEnvironment = testEnvironment;
      config.moduleStats = { all: 0, bad: 0 };

      QUnit.moduleStart( name, testEnvironment );
    });
  },

  asyncTest: function(testName, expected, callback) {
    if ( arguments.length === 2 ) {
      callback = expected;
      expected = 0;
    }

    QUnit.test(testName, expected, callback, true);
  },

  test: function(testName, expected, callback, async) {
    var name = '<span class="test-name">' + testName + '</span>', testEnvironment, testEnvironmentArg;

    if ( arguments.length === 2 ) {
      callback = expected;
      expected = null;
    }
    // is 2nd argument a testEnvironment?
    if ( expected && typeof expected === 'object') {
      testEnvironmentArg =  expected;
      expected = null;
    }

    if ( config.currentModule ) {
      name = '<span class="module-name">' + config.currentModule + "</span>: " + name;
    }

    if ( !validTest(config.currentModule + ": " + testName) ) {
      return;
    }

    synchronize(function() {

      testEnvironment = extend({
        setup: function() {},
        teardown: function() {}
      }, config.moduleTestEnvironment);
      if (testEnvironmentArg) {
        extend(testEnvironment,testEnvironmentArg);
      }

      QUnit.testStart( testName, testEnvironment );

      // allow utility functions to access the current test environment
      QUnit.current_testEnvironment = testEnvironment;

      config.assertions = [];
      config.expected = expected;

      var tests = id("qunit-tests");
      if (tests) {
        var b = document.createElement("strong");
          b.innerHTML = "Running " + name;
        var li = document.createElement("li");
          li.appendChild( b );
          li.id = "current-test-output";
        tests.appendChild( li )
      }

      try {
        if ( !config.pollution ) {
          saveGlobal();
        }

        testEnvironment.setup.call(testEnvironment);
      } catch(e) {
        QUnit.ok( false, "Setup failed on " + name + ": " + e.message );
      }
      });

      synchronize(function() {
      if ( async ) {
        QUnit.stop();
      }

      try {
        callback.call(testEnvironment);
      } catch(e) {
        fail("Test " + name + " died, exception and test follows", e, callback);
        QUnit.ok( false, "Died on test #" + (config.assertions.length + 1) + ": " + e.message );
        // else next test will carry the responsibility
        saveGlobal();

        // Restart the tests if they're blocking
        if ( config.blocking ) {
          start();
        }
      }
    });

    synchronize(function() {
      try {
        checkPollution();
        testEnvironment.teardown.call(testEnvironment);
      } catch(e) {
        QUnit.ok( false, "Teardown failed on " + name + ": " + e.message );
      }
      });

      synchronize(function() {
      try {
        QUnit.reset();
      } catch(e) {
        fail("reset() failed, following Test " + name + ", exception and reset fn follows", e, reset);
      }

      if ( config.expected && config.expected != config.assertions.length ) {
        QUnit.ok( false, "Expected " + config.expected + " assertions, but " + config.assertions.length + " were run" );
      }

      var good = 0, bad = 0,
        tests = id("qunit-tests");

      config.stats.all += config.assertions.length;
      config.moduleStats.all += config.assertions.length;

      if ( tests ) {
        var ol  = document.createElement("ol");

        for ( var i = 0; i < config.assertions.length; i++ ) {
          var assertion = config.assertions[i];

          var li = document.createElement("li");
          li.className = assertion.result ? "pass" : "fail";
          li.innerHTML = assertion.message || "(no message)";
          ol.appendChild( li );

          if ( assertion.result ) {
            good++;
          } else {
            bad++;
            config.stats.bad++;
            config.moduleStats.bad++;
          }
        }
        if (bad == 0) {
          ol.style.display = "none";
        }

        var b = document.createElement("strong");
        b.innerHTML = name + " <b style='color:black;'>(<b class='fail'>" + bad + "</b>, <b class='pass'>" + good + "</b>, " + config.assertions.length + ")</b>";

        addEvent(b, "click", function() {
          var next = b.nextSibling, display = next.style.display;
          next.style.display = display === "none" ? "block" : "none";
        });

        addEvent(b, "dblclick", function(e) {
          var target = e && e.target ? e.target : window.event.srcElement;
          if ( target.nodeName.toLowerCase() == "span" || target.nodeName.toLowerCase() == "b" ) {
            target = target.parentNode;
          }
          if ( window.location && target.nodeName.toLowerCase() === "strong" ) {
            window.location.search = "?" + encodeURIComponent(getText([target]).replace(/\(.+\)$/, "").replace(/(^\s*|\s*$)/g, ""));
          }
        });

        var li = id("current-test-output");
        li.id = "";
        li.className = bad ? "fail" : "pass";
        li.removeChild( li.firstChild );
        li.appendChild( b );
        li.appendChild( ol );

        if ( bad ) {
          var toolbar = id("qunit-testrunner-toolbar");
          if ( toolbar ) {
            toolbar.style.display = "block";
            id("qunit-filter-pass").disabled = null;
            id("qunit-filter-missing").disabled = null;
          }
        }

      } else {
        for ( var i = 0; i < config.assertions.length; i++ ) {
          if ( !config.assertions[i].result ) {
            bad++;
            config.stats.bad++;
            config.moduleStats.bad++;
          }
        }
      }

      QUnit.testDone( testName, bad, config.assertions.length );

      if ( !window.setTimeout && !config.queue.length ) {
        done();
      }
    });

    if ( window.setTimeout && !config.doneTimer ) {
      config.doneTimer = window.setTimeout(function(){
        if ( !config.queue.length ) {
          done();
        } else {
          synchronize( done );
        }
      }, 13);
    }
  },

  /**
   * Specify the number of expected assertions to gurantee that failed test (no assertions are run at all) don't slip through.
   */
  expect: function(asserts) {
    config.expected = asserts;
  },

  /**
   * Asserts true.
   * @example ok( "asdfasdf".length > 5, "There must be at least 5 chars" );
   */
  ok: function(a, msg) {
    msg = escapeHtml(msg);
    QUnit.log(a, msg);

    config.assertions.push({
      result: !!a,
      message: msg
    });
  },

  /**
   * Checks that the first two arguments are equal, with an optional message.
   * Prints out both actual and expected values.
   *
   * Prefered to ok( actual == expected, message )
   *
   * @example equal( format("Received {0} bytes.", 2), "Received 2 bytes." );
   *
   * @param Object actual
   * @param Object expected
   * @param String message (optional)
   */
  equal: function(actual, expected, message) {
    push(expected == actual, actual, expected, message);
  },

  notEqual: function(actual, expected, message) {
    push(expected != actual, actual, expected, message);
  },

  deepEqual: function(actual, expected, message) {
    push(QUnit.equiv(actual, expected), actual, expected, message);
  },

  notDeepEqual: function(actual, expected, message) {
    push(!QUnit.equiv(actual, expected), actual, expected, message);
  },

  strictEqual: function(actual, expected, message) {
    push(expected === actual, actual, expected, message);
  },

  notStrictEqual: function(actual, expected, message) {
    push(expected !== actual, actual, expected, message);
  },

  raises: function(fn,  message) {
    try {
      fn();
      ok( false, message );
    }
    catch (e) {
      ok( true, message );
    }
  },

  start: function() {
    // A slight delay, to avoid any current callbacks
    if ( window.setTimeout ) {
      window.setTimeout(function() {
        if ( config.timeout ) {
          clearTimeout(config.timeout);
        }

        config.blocking = false;
        process();
      }, 13);
    } else {
      config.blocking = false;
      process();
    }
  },

  stop: function(timeout) {
    config.blocking = true;

    if ( timeout && window.setTimeout ) {
      config.timeout = window.setTimeout(function() {
        QUnit.ok( false, "Test timed out" );
        QUnit.start();
      }, timeout);
    }
  }

};

// Backwards compatibility, deprecated
QUnit.equals = QUnit.equal;
QUnit.same = QUnit.deepEqual;

// Maintain internal state
var config = {
  // The queue of tests to run
  queue: [],

  // block until document ready
  blocking: true
};

// Load paramaters
(function() {
  var location = window.location || { search: "", protocol: "file:" },
    GETParams = location.search.slice(1).split('&');

  for ( var i = 0; i < GETParams.length; i++ ) {
    GETParams[i] = decodeURIComponent( GETParams[i] );
    if ( GETParams[i] === "noglobals" ) {
      GETParams.splice( i, 1 );
      i--;
      config.noglobals = true;
    } else if ( GETParams[i].search('=') > -1 ) {
      GETParams.splice( i, 1 );
      i--;
    }
  }

  // restrict modules/tests by get parameters
  config.filters = GETParams;

  // Figure out if we're running the tests from a server or not
  QUnit.isLocal = !!(location.protocol === 'file:');
})();

// Expose the API as global variables, unless an 'exports'
// object exists, in that case we assume we're in CommonJS
if ( typeof exports === "undefined" || typeof require === "undefined" ) {
  extend(window, QUnit);
  window.QUnit = QUnit;
} else {
  extend(exports, QUnit);
  exports.QUnit = QUnit;
}

// define these after exposing globals to keep them in these QUnit namespace only
extend(QUnit, {
  config: config,

  // Initialize the configuration options
  init: function() {
    extend(config, {
      stats: { all: 0, bad: 0 },
      moduleStats: { all: 0, bad: 0 },
      started: +new Date,
      updateRate: 1000,
      blocking: false,
      autostart: true,
      autorun: false,
      assertions: [],
      filters: [],
      queue: []
    });

    var tests = id("qunit-tests"),
      banner = id("qunit-banner"),
      result = id("qunit-testresult");

    if ( tests ) {
      tests.innerHTML = "";
    }

    if ( banner ) {
      banner.className = "";
    }

    if ( result ) {
      result.parentNode.removeChild( result );
    }
  },

  /**
   * Resets the test setup. Useful for tests that modify the DOM.
   */
  reset: function() {
    if ( window.jQuery ) {
      jQuery("#main, #qunit-fixture").html( config.fixture );
    }
  },

  /**
   * Trigger an event on an element.
   *
   * @example triggerEvent( document.body, "click" );
   *
   * @param DOMElement elem
   * @param String type
   */
  triggerEvent: function( elem, type, event ) {
    if ( document.createEvent ) {
      event = document.createEvent("MouseEvents");
      event.initMouseEvent(type, true, true, elem.ownerDocument.defaultView,
        0, 0, 0, 0, 0, false, false, false, false, 0, null);
      elem.dispatchEvent( event );

    } else if ( elem.fireEvent ) {
      elem.fireEvent("on"+type);
    }
  },

  // Safe object type checking
  is: function( type, obj ) {
    return QUnit.objectType( obj ) == type;
  },

  objectType: function( obj ) {
    if (typeof obj === "undefined") {
        return "undefined";

    // consider: typeof null === object
    }
    if (obj === null) {
        return "null";
    }

    var type = Object.prototype.toString.call( obj )
      .match(/^\[object\s(.*)\]$/)[1] || '';

    switch (type) {
        case 'Number':
            if (isNaN(obj)) {
                return "nan";
            } else {
                return "number";
            }
        case 'String':
        case 'Boolean':
        case 'Array':
        case 'Date':
        case 'RegExp':
        case 'Function':
            return type.toLowerCase();
    }
    if (typeof obj === "object") {
        return "object";
    }
    return undefined;
  },

  // Logging callbacks
  begin: function() {},
  done: function(failures, total) {},
  log: function(result, message) {},
  testStart: function(name, testEnvironment) {},
  testDone: function(name, failures, total) {},
  moduleStart: function(name, testEnvironment) {},
  moduleDone: function(name, failures, total) {}
});

if ( typeof document === "undefined" || document.readyState === "complete" ) {
  config.autorun = true;
}

addEvent(window, "load", function() {
  QUnit.begin();

  // Initialize the config, saving the execution queue
  var oldconfig = extend({}, config);
  QUnit.init();
  extend(config, oldconfig);

  config.blocking = false;

  var userAgent = id("qunit-userAgent");
  if ( userAgent ) {
    userAgent.innerHTML = navigator.userAgent;
  }

  var toolbar = id("qunit-testrunner-toolbar");
  if ( toolbar ) {
    toolbar.style.display = "none";

    var filter = document.createElement("input");
    filter.type = "checkbox";
    filter.id = "qunit-filter-pass";
    filter.disabled = true;
    addEvent( filter, "click", function() {
      var li = document.getElementsByTagName("li");
      for ( var i = 0; i < li.length; i++ ) {
        if ( li[i].className.indexOf("pass") > -1 ) {
          li[i].style.display = filter.checked ? "none" : "";
        }
      }
    });
    toolbar.appendChild( filter );

    var label = document.createElement("label");
    label.setAttribute("for", "qunit-filter-pass");
    label.innerHTML = "Hide passed tests";
    toolbar.appendChild( label );

    var missing = document.createElement("input");
    missing.type = "checkbox";
    missing.id = "qunit-filter-missing";
    missing.disabled = true;
    addEvent( missing, "click", function() {
      var li = document.getElementsByTagName("li");
      for ( var i = 0; i < li.length; i++ ) {
        if ( li[i].className.indexOf("fail") > -1 && li[i].innerHTML.indexOf('missing test - untested code is broken code') > - 1 ) {
          li[i].parentNode.parentNode.style.display = missing.checked ? "none" : "block";
        }
      }
    });
    toolbar.appendChild( missing );

    label = document.createElement("label");
    label.setAttribute("for", "qunit-filter-missing");
    label.innerHTML = "Hide missing tests (untested code is broken code)";
    toolbar.appendChild( label );
  }

  var main = id('main') || id('qunit-fixture');
  if ( main ) {
    config.fixture = main.innerHTML;
  }

  if (config.autostart) {
    QUnit.start();
  }
});

function done() {
  if ( config.doneTimer && window.clearTimeout ) {
    window.clearTimeout( config.doneTimer );
    config.doneTimer = null;
  }

  if ( config.queue.length ) {
    config.doneTimer = window.setTimeout(function(){
      if ( !config.queue.length ) {
        done();
      } else {
        synchronize( done );
      }
    }, 13);

    return;
  }

  config.autorun = true;

  // Log the last module results
  if ( config.currentModule ) {
    QUnit.moduleDone( config.currentModule, config.moduleStats.bad, config.moduleStats.all );
  }

  var banner = id("qunit-banner"),
    tests = id("qunit-tests"),
    html = ['Tests completed in ',
    +new Date - config.started, ' milliseconds.<br/>',
    '<span class="passed">', config.stats.all - config.stats.bad, '</span> tests of <span class="total">', config.stats.all, '</span> passed, <span class="failed">', config.stats.bad,'</span> failed.'].join('');

  if ( banner ) {
    banner.className = (config.stats.bad ? "qunit-fail" : "qunit-pass");
  }

  if ( tests ) {
    var result = id("qunit-testresult");

    if ( !result ) {
      result = document.createElement("p");
      result.id = "qunit-testresult";
      result.className = "result";
      tests.parentNode.insertBefore( result, tests.nextSibling );
    }

    result.innerHTML = html;
  }

  QUnit.done( config.stats.bad, config.stats.all );
}

function validTest( name ) {
  var i = config.filters.length,
    run = false;

  if ( !i ) {
    return true;
  }

  while ( i-- ) {
    var filter = config.filters[i],
      not = filter.charAt(0) == '!';

    if ( not ) {
      filter = filter.slice(1);
    }

    if ( name.indexOf(filter) !== -1 ) {
      return !not;
    }

    if ( not ) {
      run = true;
    }
  }

  return run;
}

function escapeHtml(s) {
  s = s === null ? "" : s + "";
  return s.replace(/[\&"<>\\]/g, function(s) {
    switch(s) {
      case "&": return "&amp;";
      case "\\": return "\\\\";;
      case '"': return '\"';;
      case "<": return "&lt;";
      case ">": return "&gt;";
      default: return s;
    }
  });
}

function push(result, actual, expected, message) {
  message = escapeHtml(message) || (result ? "okay" : "failed");
  message = '<span class="test-message">' + message + "</span>";
  expected = escapeHtml(QUnit.jsDump.parse(expected));
  actual = escapeHtml(QUnit.jsDump.parse(actual));
  var output = message + ', expected: <span class="test-expected">' + expected + '</span>';
  if (actual != expected) {
    output += ' result: <span class="test-actual">' + actual + '</span>, diff: ' + QUnit.diff(expected, actual);
  }

  // can't use ok, as that would double-escape messages
  QUnit.log(result, output);
  config.assertions.push({
    result: !!result,
    message: output
  });
}

function synchronize( callback ) {
  config.queue.push( callback );

  if ( config.autorun && !config.blocking ) {
    process();
  }
}

function process() {
  var start = (new Date()).getTime();

  while ( config.queue.length && !config.blocking ) {
    if ( config.updateRate <= 0 || (((new Date()).getTime() - start) < config.updateRate) ) {
      config.queue.shift()();

    } else {
      setTimeout( process, 13 );
      break;
    }
  }
}

function saveGlobal() {
  config.pollution = [];

  if ( config.noglobals ) {
    for ( var key in window ) {
      config.pollution.push( key );
    }
  }
}

function checkPollution( name ) {
  var old = config.pollution;
  saveGlobal();

  var newGlobals = diff( old, config.pollution );
  if ( newGlobals.length > 0 ) {
    ok( false, "Introduced global variable(s): " + newGlobals.join(", ") );
    config.expected++;
  }

  var deletedGlobals = diff( config.pollution, old );
  if ( deletedGlobals.length > 0 ) {
    ok( false, "Deleted global variable(s): " + deletedGlobals.join(", ") );
    config.expected++;
  }
}

// returns a new Array with the elements that are in a but not in b
function diff( a, b ) {
  var result = a.slice();
  for ( var i = 0; i < result.length; i++ ) {
    for ( var j = 0; j < b.length; j++ ) {
      if ( result[i] === b[j] ) {
        result.splice(i, 1);
        i--;
        break;
      }
    }
  }
  return result;
}

function fail(message, exception, callback) {
  if ( typeof console !== "undefined" && console.error && console.warn ) {
    console.error(message);
    console.error(exception);
    console.warn(callback.toString());

  } else if ( window.opera && opera.postError ) {
    opera.postError(message, exception, callback.toString);
  }
}

function extend(a, b) {
  for ( var prop in b ) {
    a[prop] = b[prop];
  }

  return a;
}

function addEvent(elem, type, fn) {
  if ( elem.addEventListener ) {
    elem.addEventListener( type, fn, false );
  } else if ( elem.attachEvent ) {
    elem.attachEvent( "on" + type, fn );
  } else {
    fn();
  }
}

function id(name) {
  return !!(typeof document !== "undefined" && document && document.getElementById) &&
    document.getElementById( name );
}

// Test for equality any JavaScript type.
// Discussions and reference: http://philrathe.com/articles/equiv
// Test suites: http://philrathe.com/tests/equiv
// Author: Philippe Rathé <prathe@gmail.com>
QUnit.equiv = function () {

    var innerEquiv; // the real equiv function
    var callers = []; // stack to decide between skip/abort functions
    var parents = []; // stack to avoiding loops from circular referencing

    // Call the o related callback with the given arguments.
    function bindCallbacks(o, callbacks, args) {
        var prop = QUnit.objectType(o);
        if (prop) {
            if (QUnit.objectType(callbacks[prop]) === "function") {
                return callbacks[prop].apply(callbacks, args);
            } else {
                return callbacks[prop]; // or undefined
            }
        }
    }

    var callbacks = function () {

        // for string, boolean, number and null
        function useStrictEquality(b, a) {
            if (b instanceof a.constructor || a instanceof b.constructor) {
                // to catch short annotaion VS 'new' annotation of a declaration
                // e.g. var i = 1;
                //      var j = new Number(1);
                return a == b;
            } else {
                return a === b;
            }
        }

        return {
            "string": useStrictEquality,
            "boolean": useStrictEquality,
            "number": useStrictEquality,
            "null": useStrictEquality,
            "undefined": useStrictEquality,

            "nan": function (b) {
                return isNaN(b);
            },

            "date": function (b, a) {
                return QUnit.objectType(b) === "date" && a.valueOf() === b.valueOf();
            },

            "regexp": function (b, a) {
                return QUnit.objectType(b) === "regexp" &&
                    a.source === b.source && // the regex itself
                    a.global === b.global && // and its modifers (gmi) ...
                    a.ignoreCase === b.ignoreCase &&
                    a.multiline === b.multiline;
            },

            // - skip when the property is a method of an instance (OOP)
            // - abort otherwise,
            //   initial === would have catch identical references anyway
            "function": function () {
                var caller = callers[callers.length - 1];
                return caller !== Object &&
                        typeof caller !== "undefined";
            },

            "array": function (b, a) {
                var i, j, loop;
                var len;

                // b could be an object literal here
                if ( ! (QUnit.objectType(b) === "array")) {
                    return false;
                }

                len = a.length;
                if (len !== b.length) { // safe and faster
                    return false;
                }

                //track reference to avoid circular references
                parents.push(a);
                for (i = 0; i < len; i++) {
                    loop = false;
                    for(j=0;j<parents.length;j++){
                        if(parents[j] === a[i]){
                            loop = true;//dont rewalk array
                        }
                    }
                    if (!loop && ! innerEquiv(a[i], b[i])) {
                        parents.pop();
                        return false;
                    }
                }
                parents.pop();
                return true;
            },

            "object": function (b, a) {
                var i, j, loop;
                var eq = true; // unless we can proove it
                var aProperties = [], bProperties = []; // collection of strings

                // comparing constructors is more strict than using instanceof
                if ( a.constructor !== b.constructor) {
                    return false;
                }

                // stack constructor before traversing properties
                callers.push(a.constructor);
                //track reference to avoid circular references
                parents.push(a);

                for (i in a) { // be strict: don't ensures hasOwnProperty and go deep
                    loop = false;
                    for(j=0;j<parents.length;j++){
                        if(parents[j] === a[i])
                            loop = true; //don't go down the same path twice
                    }
                    aProperties.push(i); // collect a's properties

                    if (!loop && ! innerEquiv(a[i], b[i])) {
                        eq = false;
                        break;
                    }
                }

                callers.pop(); // unstack, we are done
                parents.pop();

                for (i in b) {
                    bProperties.push(i); // collect b's properties
                }

                // Ensures identical properties name
                return eq && innerEquiv(aProperties.sort(), bProperties.sort());
            }
        };
    }();

    innerEquiv = function () { // can take multiple arguments
        var args = Array.prototype.slice.apply(arguments);
        if (args.length < 2) {
            return true; // end transition
        }

        return (function (a, b) {
            if (a === b) {
                return true; // catch the most you can
            } else if (a === null || b === null || typeof a === "undefined" || typeof b === "undefined" || QUnit.objectType(a) !== QUnit.objectType(b)) {
                return false; // don't lose time with error prone cases
            } else {
                return bindCallbacks(a, callbacks, [b, a]);
            }

        // apply transition with (1..n) arguments
        })(args[0], args[1]) && arguments.callee.apply(this, args.splice(1, args.length -1));
    };

    return innerEquiv;

}();

/**
 * jsDump
 * Copyright (c) 2008 Ariel Flesler - aflesler(at)gmail(dot)com | http://flesler.blogspot.com
 * Licensed under BSD (http://www.opensource.org/licenses/bsd-license.php)
 * Date: 5/15/2008
 * @projectDescription Advanced and extensible data dumping for Javascript.
 * @version 1.0.0
 * @author Ariel Flesler
 * @link {http://flesler.blogspot.com/2008/05/jsdump-pretty-dump-of-any-javascript.html}
 */
QUnit.jsDump = (function() {
  function quote( str ) {
    return '"' + str.toString().replace(/"/g, '\\"') + '"';
  };
  function literal( o ) {
    return o + '';
  };
  function join( pre, arr, post ) {
    var s = jsDump.separator(),
      base = jsDump.indent(),
      inner = jsDump.indent(1);
    if ( arr.join )
      arr = arr.join( ',' + s + inner );
    if ( !arr )
      return pre + post;
    return [ pre, inner + arr, base + post ].join(s);
  };
  function array( arr ) {
    var i = arr.length, ret = Array(i);
    this.up();
    while ( i-- )
      ret[i] = this.parse( arr[i] );
    this.down();
    return join( '[', ret, ']' );
  };

  var reName = /^function (\w+)/;

  var jsDump = {
    parse:function( obj, type ) { //type is used mostly internally, you can fix a (custom)type in advance
      var parser = this.parsers[ type || this.typeOf(obj) ];
      type = typeof parser;

      return type == 'function' ? parser.call( this, obj ) :
           type == 'string' ? parser :
           this.parsers.error;
    },
    typeOf:function( obj ) {
      var type;
      if ( obj === null ) {
        type = "null";
      } else if (typeof obj === "undefined") {
        type = "undefined";
      } else if (QUnit.is("RegExp", obj)) {
        type = "regexp";
      } else if (QUnit.is("Date", obj)) {
        type = "date";
      } else if (QUnit.is("Function", obj)) {
        type = "function";
      } else if (obj.setInterval && obj.document && !obj.nodeType) {
        type = "window";
      } else if (obj.nodeType === 9) {
        type = "document";
      } else if (obj.nodeType) {
        type = "node";
      } else if (typeof obj === "object" && typeof obj.length === "number" && obj.length >= 0) {
        type = "array";
      } else {
        type = typeof obj;
      }
      return type;
    },
    separator:function() {
      return this.multiline ? this.HTML ? '<br />' : '\n' : this.HTML ? '&nbsp;' : ' ';
    },
    indent:function( extra ) {// extra can be a number, shortcut for increasing-calling-decreasing
      if ( !this.multiline )
        return '';
      var chr = this.indentChar;
      if ( this.HTML )
        chr = chr.replace(/\t/g,'   ').replace(/ /g,'&nbsp;');
      return Array( this._depth_ + (extra||0) ).join(chr);
    },
    up:function( a ) {
      this._depth_ += a || 1;
    },
    down:function( a ) {
      this._depth_ -= a || 1;
    },
    setParser:function( name, parser ) {
      this.parsers[name] = parser;
    },
    // The next 3 are exposed so you can use them
    quote:quote,
    literal:literal,
    join:join,
    //
    _depth_: 1,
    // This is the list of parsers, to modify them, use jsDump.setParser
    parsers:{
      window: '[Window]',
      document: '[Document]',
      error:'[ERROR]', //when no parser is found, shouldn't happen
      unknown: '[Unknown]',
      'null':'null',
      undefined:'undefined',
      'function':function( fn ) {
        var ret = 'function',
          name = 'name' in fn ? fn.name : (reName.exec(fn)||[])[1];//functions never have name in IE
        if ( name )
          ret += ' ' + name;
        ret += '(';

        ret = [ ret, this.parse( fn, 'functionArgs' ), '){'].join('');
        return join( ret, this.parse(fn,'functionCode'), '}' );
      },
      array: array,
      nodelist: array,
      arguments: array,
      object:function( map ) {
        var ret = [ ];
        this.up();
        for ( var key in map )
          ret.push( this.parse(key,'key') + ': ' + this.parse(map[key]) );
        this.down();
        return join( '{', ret, '}' );
      },
      node:function( node ) {
        var open = this.HTML ? '&lt;' : '<',
          close = this.HTML ? '&gt;' : '>';

        var tag = node.nodeName.toLowerCase(),
          ret = open + tag;

        for ( var a in this.DOMAttrs ) {
          var val = node[this.DOMAttrs[a]];
          if ( val )
            ret += ' ' + a + '=' + this.parse( val, 'attribute' );
        }
        return ret + close + open + '/' + tag + close;
      },
      functionArgs:function( fn ) {//function calls it internally, it's the arguments part of the function
        var l = fn.length;
        if ( !l ) return '';

        var args = Array(l);
        while ( l-- )
          args[l] = String.fromCharCode(97+l);//97 is 'a'
        return ' ' + args.join(', ') + ' ';
      },
      key:quote, //object calls it internally, the key part of an item in a map
      functionCode:'[code]', //function calls it internally, it's the content of the function
      attribute:quote, //node calls it internally, it's an html attribute value
      string:quote,
      date:quote,
      regexp:literal, //regex
      number:literal,
      'boolean':literal
    },
    DOMAttrs:{//attributes to dump from nodes, name=>realName
      id:'id',
      name:'name',
      'class':'className'
    },
    HTML:false,//if true, entities are escaped ( <, >, \t, space and \n )
    indentChar:'   ',//indentation unit
    multiline:false //if true, items in a collection, are separated by a \n, else just a space.
  };

  return jsDump;
})();

// from Sizzle.js
function getText( elems ) {
  var ret = "", elem;

  for ( var i = 0; elems[i]; i++ ) {
    elem = elems[i];

    // Get the text from text nodes and CDATA nodes
    if ( elem.nodeType === 3 || elem.nodeType === 4 ) {
      ret += elem.nodeValue;

    // Traverse everything else, except comment nodes
    } else if ( elem.nodeType !== 8 ) {
      ret += getText( elem.childNodes );
    }
  }

  return ret;
};

/*
 * Javascript Diff Algorithm
 *  By John Resig (http://ejohn.org/)
 *  Modified by Chu Alan "sprite"
 *
 * Released under the MIT license.
 *
 * More Info:
 *  http://ejohn.org/projects/javascript-diff-algorithm/
 *
 * Usage: QUnit.diff(expected, actual)
 *
 * QUnit.diff("the quick brown fox jumped over", "the quick fox jumps over") == "the  quick <del>brown </del> fox <del>jumped </del><ins>jumps </ins> over"
 */
QUnit.diff = (function() {
  function escape(s){
    var n = s;
    n = n.replace(/&/g, "&amp;");
    n = n.replace(/</g, "&lt;");
    n = n.replace(/>/g, "&gt;");
    n = n.replace(/"/g, "&quot;");

    return n;
  }

  function diff(o, n){
    var ns = new Object();
    var os = new Object();

    for (var i = 0; i < n.length; i++) {
      if (ns[n[i]] == null)
        ns[n[i]] = {
          rows: new Array(),
          o: null
        };
      ns[n[i]].rows.push(i);
    }

    for (var i = 0; i < o.length; i++) {
      if (os[o[i]] == null)
        os[o[i]] = {
          rows: new Array(),
          n: null
        };
      os[o[i]].rows.push(i);
    }

    for (var i in ns) {
      if (ns[i].rows.length == 1 && typeof(os[i]) != "undefined" && os[i].rows.length == 1) {
        n[ns[i].rows[0]] = {
          text: n[ns[i].rows[0]],
          row: os[i].rows[0]
        };
        o[os[i].rows[0]] = {
          text: o[os[i].rows[0]],
          row: ns[i].rows[0]
        };
      }
    }

    for (var i = 0; i < n.length - 1; i++) {
      if (n[i].text != null && n[i + 1].text == null && n[i].row + 1 < o.length && o[n[i].row + 1].text == null &&
      n[i + 1] == o[n[i].row + 1]) {
        n[i + 1] = {
          text: n[i + 1],
          row: n[i].row + 1
        };
        o[n[i].row + 1] = {
          text: o[n[i].row + 1],
          row: i + 1
        };
      }
    }

    for (var i = n.length - 1; i > 0; i--) {
      if (n[i].text != null && n[i - 1].text == null && n[i].row > 0 && o[n[i].row - 1].text == null &&
      n[i - 1] == o[n[i].row - 1]) {
        n[i - 1] = {
          text: n[i - 1],
          row: n[i].row - 1
        };
        o[n[i].row - 1] = {
          text: o[n[i].row - 1],
          row: i - 1
        };
      }
    }

    return {
      o: o,
      n: n
    };
  }

  return function(o, n){
    o = o.replace(/\s+$/, '');
    n = n.replace(/\s+$/, '');
    var out = diff(o == "" ? [] : o.split(/\s+/), n == "" ? [] : n.split(/\s+/));

    var str = "";

    var oSpace = o.match(/\s+/g);
    if (oSpace == null) {
      oSpace = ["\n"];
    }
    else {
      oSpace.push("\n");
    }
    var nSpace = n.match(/\s+/g);
    if (nSpace == null) {
      nSpace = ["\n"];
    }
    else {
      nSpace.push("\n");
    }

    if (out.n.length == 0) {
      for (var i = 0; i < out.o.length; i++) {
        str += '<del>' + escape(out.o[i]) + oSpace[i] + "</del>";
      }
    }
    else {
      if (out.n[0].text == null) {
        for (n = 0; n < out.o.length && out.o[n].text == null; n++) {
          str += '<del>' + escape(out.o[n]) + oSpace[n] + "</del>";
        }
      }

      for (var i = 0; i < out.n.length; i++) {
        if (out.n[i].text == null) {
          str += '<ins>' + escape(out.n[i]) + nSpace[i] + "</ins>";
        }
        else {
          var pre = "";

          for (n = out.n[i].row + 1; n < out.o.length && out.o[n].text == null; n++) {
            pre += '<del>' + escape(out.o[n]) + oSpace[n] + "</del>";
          }
          str += " " + out.n[i].text + nSpace[i] + pre;
        }
      }
    }

    return str;
  }
})();

})(this);
(function() {

  module("Array");

  test("#average", function() {
    return equals([1, 3, 5, 7].average(), 4);
  });

  test("#compact", function() {
    var a, compacted;
    a = [0, 1, void 0, 2, null, 3, '', 4];
    compacted = a.compact();
    equals(compacted[0], 0);
    equals(compacted[1], 1);
    equals(compacted[2], 2);
    equals(compacted[3], 3);
    equals(compacted[4], '');
    return equals(compacted[5], 4);
  });

  test("#copy", function() {
    var a, b;
    a = [1, 2, 3];
    b = a.copy();
    ok(a !== b, "Original array is not the same array as the copied one");
    ok(a.length === b.length, "Both arrays are the same size");
    return ok(a[0] === b[0] && a[1] === b[1] && a[2] === b[2], "The elements of the two arrays are equal");
  });

  test("#flatten", function() {
    var array, flattenedArray;
    array = [[0, 1], [2, 3], [4, 5]];
    flattenedArray = array.flatten();
    equals(flattenedArray.length, 6, "Flattened array length should equal number of elements in sub-arrays");
    equals(flattenedArray.first(), 0, "First element should be first element in first sub-array");
    return equals(flattenedArray.last(), 5, "Last element should be last element in last sub-array");
  });

  test("#rand", function() {
    var array;
    array = [1, 2, 3];
    ok(array.indexOf(array.rand()) !== -1, "Array includes randomly selected element");
    ok([5].rand() === 5, "[5].rand() === 5");
    return ok([].rand() === void 0, "[].rand() === undefined");
  });

  test("#remove", function() {
    var array;
    equals([1, 2, 3].remove(2), 2, "[1,2,3].remove(2) === 2");
    equals([1, 3].remove(2), void 0, "[1,3].remove(2) === undefined");
    equals([1, 3].remove(3), 3, "[1,3].remove(3) === 3");
    array = [1, 2, 3];
    array.remove(2);
    ok(array.length === 2, "array = [1,2,3]; array.remove(2); array.length === 2");
    array.remove(3);
    return ok(array.length === 1, "array = [1,3]; array.remove(3); array.length === 1");
  });

  test("#map", function() {
    return equals([1].map(function(x) {
      return x + 1;
    })[0], 2);
  });

  test("#invoke", function() {
    var results;
    results = ['hello', 'world', 'cool!'].invoke('substring', 0, 3);
    equals(results[0], "hel");
    equals(results[1], "wor");
    return equals(results[2], "coo");
  });

  test("#each", function() {
    var array, count;
    array = [1, 2, 3];
    count = 0;
    equals(array, array.each(function() {
      return count++;
    }));
    return equals(array.length, count);
  });

  test("#eachPair", function() {
    var array, sum;
    array = [1, 2, 3];
    sum = 0;
    array.eachPair(function(a, b) {
      return sum += a + b;
    });
    return equals(sum, 12);
  });

  test("#eachWithObject", function() {
    var array, result;
    array = [1, 2, 3];
    result = array.eachWithObject({}, function(element, hash) {
      return hash[element] = (element + 1).toString();
    });
    equals(result[1], "2");
    equals(result[2], "3");
    return equals(result[3], "4");
  });

  test("#shuffle", function() {
    var array, shuffledArray;
    array = [0, 1, 2, 3, 4, 5];
    shuffledArray = array.shuffle();
    shuffledArray.each(function(element) {
      return ok(array.indexOf(element) >= 0, "Every element in shuffled array is in orig array");
    });
    return array.each(function(element) {
      return ok(shuffledArray.indexOf(element) >= 0, "Every element in orig array is in shuffled array");
    });
  });

  test("#first", function() {
    equals([2].first(), 2);
    equals([1, 2, 3].first(), 1);
    return equals([].first(), void 0);
  });

  test("#last", function() {
    equals([2].last(), 2);
    equals([1, 2, 3].last(), 3);
    return equals([].first(), void 0);
  });

  test("#extremes", function() {
    var array, extremes;
    array = [-7, 1, 11, 94];
    extremes = array.extremes();
    equals(extremes.min, -7, "Min is -7");
    equals(extremes.max, 94, "Max is 94");
    extremes = array.extremes(function(value) {
      return value.mod(11);
    });
    equals(extremes.min, 11);
    return equals(extremes.max, 94);
  });

  test("#sum", function() {
    equals([].sum(), 0, "Empty array sums to zero");
    equals([2].sum(), 2, "[2] sums to 2");
    return equals([1, 2, 3, 4, 5].sum(), 15, "[1, 2, 3, 4, 5] sums to 15");
  });

  test("#eachSlice", 6, function() {
    return [1, 2, 3, 4, 5, 6].eachSlice(2, function(array) {
      equals(array[0] % 2, 1);
      return equals(array[1] % 2, 0);
    });
  });

  test("#without", function() {
    var array, excluded;
    array = [1, 2, 3, 4];
    excluded = array.without([2, 4]);
    equals(excluded[0], 1);
    return equals(excluded[1], 3);
  });

  test("#clear", function() {
    var array;
    array = [1, 2, 3, 4];
    equals(array.length, 4);
    equals(array[0], 1);
    array.clear();
    equals(array.length, 0);
    return equals(array[0], void 0);
  });

  test("#wrap", function() {
    var array;
    array = [0, 1, 2, 3, 4];
    equals(array.wrap(0), 0);
    equals(array.wrap(-1), 4);
    return equals(array.wrap(2), 2);
  });

  test("#zip", function() {
    var a, b, c, output;
    a = [1, 2, 3];
    b = [4, 5, 6];
    c = [7, 8];
    output = a.zip(b, c);
    equals(output[0][0], 1);
    equals(output[0][1], 4);
    equals(output[0][2], 7);
    return equals(output[2][2], void 0);
  });

  module(void 0);

}).call(this);
(function() {

  module("Bindable");

  test("#bind and #trigger", 1, function() {
    var o;
    o = Core().include("Bindable");
    o.bind("test", function() {
      return ok(true);
    });
    return o.trigger("test");
  });

  test("Multiple bindings", 2, function() {
    var o;
    o = Core().include(Bindable);
    o.bind("test", function() {
      return ok(true);
    });
    o.bind("test", function() {
      return ok(true);
    });
    return o.trigger("test");
  });

  test("#trigger arguments", function() {
    var o, param1, param2;
    o = Core().include(Bindable);
    param1 = "the message";
    param2 = 3;
    o.bind("test", function(p1, p2) {
      equal(p1, param1);
      return equal(p2, param2);
    });
    return o.trigger("test", param1, param2);
  });

  test("#unbind", function() {
    var callback, o;
    o = Core().include("Bindable");
    callback = function() {
      return ok(false);
    };
    o.bind("test", callback);
    o.unbind("test", callback);
    o.trigger("test");
    o.bind("test", callback);
    o.unbind("test");
    return o.trigger("test");
  });

  test("#trigger namespace", 1, function() {
    var o;
    o = Core().include("Bindable");
    o.bind("test.TestNamespace", function() {
      return ok(true);
    });
    o.trigger("test");
    o.unbind(".TestNamespace");
    return o.trigger("test");
  });

  test("#unbind namespaced", 1, function() {
    var o;
    o = Core().include("Bindable");
    o.bind("test.TestNamespace", function() {
      return ok(true);
    });
    o.trigger("test");
    o.unbind(".TestNamespace", function() {});
    return o.trigger("test");
  });

  module();

}).call(this);
(function() {

  module("CommandStack");

  test("undo on an empty stack returns undefined", function() {
    var commandStack;
    commandStack = CommandStack();
    return equals(commandStack.undo(), void 0);
  });

  test("redo on an empty stack returns undefined", function() {
    var commandStack;
    commandStack = CommandStack();
    return equals(commandStack.redo(), void 0);
  });

  test("executes commands", 1, function() {
    var command, commandStack;
    command = {
      execute: function() {
        return ok(true, "command executed");
      }
    };
    commandStack = CommandStack();
    return commandStack.execute(command);
  });

  test("can undo", 1, function() {
    var command, commandStack;
    command = {
      execute: function() {},
      undo: function() {
        return ok(true, "command executed");
      }
    };
    commandStack = CommandStack();
    commandStack.execute(command);
    return commandStack.undo();
  });

  test("can redo", 2, function() {
    var command, commandStack;
    command = {
      execute: function() {
        return ok(true, "command executed");
      },
      undo: function() {}
    };
    commandStack = CommandStack();
    commandStack.execute(command);
    commandStack.undo();
    return commandStack.redo();
  });

  test("executes redone command once on redo", 4, function() {
    var command, commandStack;
    command = {
      execute: function() {
        return ok(true, "command executed");
      },
      undo: function() {}
    };
    commandStack = CommandStack();
    commandStack.execute(command);
    commandStack.undo();
    commandStack.redo();
    equals(commandStack.redo(), void 0);
    return equals(commandStack.redo(), void 0);
  });

  test("command is returned when undone", function() {
    var command, commandStack;
    command = {
      execute: function() {},
      undo: function() {}
    };
    commandStack = CommandStack();
    commandStack.execute(command);
    return equals(commandStack.undo(), command, "Undone command is returned");
  });

  test("command is returned when redone", function() {
    var command, commandStack;
    command = {
      execute: function() {},
      undo: function() {}
    };
    commandStack = CommandStack();
    commandStack.execute(command);
    commandStack.undo();
    return equals(commandStack.redo(), command, "Redone command is returned");
  });

  test("cannot redo an obsolete future", function() {
    var Command, commandStack;
    Command = function() {
      return {
        execute: function() {},
        undo: function() {}
      };
    };
    commandStack = CommandStack();
    commandStack.execute(Command());
    commandStack.execute(Command());
    commandStack.undo();
    commandStack.undo();
    equals(commandStack.canRedo(), true);
    commandStack.execute(Command());
    return equals(commandStack.canRedo(), false);
  });

  module();

}).call(this);
(function() {

  module("Core");

  test("#extend", function() {
    var o;
    o = Core();
    o.extend({
      test: "jawsome"
    });
    return equals(o.test, "jawsome");
  });

  test("#attrAccessor", function() {
    var o;
    o = Core({
      test: "my_val"
    });
    o.attrAccessor("test");
    equals(o.test(), "my_val");
    equals(o.test("new_val"), o);
    return equals(o.test(), "new_val");
  });

  test("#attrReader", function() {
    var o;
    o = Core({
      test: "my_val"
    });
    o.attrReader("test");
    equals(o.test(), "my_val");
    equals(o.test("new_val"), "my_val");
    return equals(o.test(), "my_val");
  });

  test("#include", function() {
    var M, o, ret;
    o = Core({
      test: "my_val"
    });
    M = function(I, self) {
      self.attrReader("test");
      return {
        test2: "cool"
      };
    };
    ret = o.include(M);
    equals(ret, o, "Should return self");
    equals(o.test(), "my_val");
    return equals(o.test2, "cool");
  });

  test("#include same module twice", 1, function() {
    var o;
    window.M = function(I, self) {
      ok(true);
      return {
        test: true
      };
    };
    o = Core();
    o.include(M);
    return o.include(M);
  });

  test("#include multiple", function() {
    var M, M2, o;
    o = Core({
      test: "my_val"
    });
    M = function(I, self) {
      self.attrReader("test");
      return {
        test2: "cool"
      };
    };
    M2 = function(I, self) {
      return {
        test2: "coolio"
      };
    };
    o.include(M, M2);
    return equals(o.test2, "coolio");
  });

  test("#include string", function() {
    var o;
    window.TestM = function(I, self) {
      self.attrReader("test");
      return {
        test2: "cool"
      };
    };
    o = Core({
      test: "my_val"
    });
    o.include("TestM");
    return equals(o.test(), "my_val");
  });

  test("#send", function() {
    var o;
    o = Core({
      test: true
    });
    o.send("attrAccessor", "test");
    return ok(o.test());
  });

  module(void 0);

}).call(this);
(function() {

  module("Function");

  test("#once", function() {
    var addScore, onceScore, score;
    score = 0;
    addScore = function() {
      return score += 100;
    };
    onceScore = addScore.once();
    100..times(function() {
      return onceScore();
    });
    return equals(score, 100);
  });

  test("#returning", function() {
    var returnValue, sideEffectsAdd, x;
    x = 0;
    sideEffectsAdd = function(a) {
      return x += a;
    };
    returnValue = sideEffectsAdd.returning(-1)(4);
    equals(x, 4);
    return equals(returnValue, -1);
  });

  asyncTest("#debounce", 1, function() {
    var fn;
    fn = (function() {
      ok(true);
      return start();
    }).debounce(50);
    fn();
    fn();
    return fn();
  });

  asyncTest("#delay", 2, function() {
    var fn;
    fn = function(x, y) {
      equals(x, 3);
      equals(y, "testy");
      return start();
    };
    return fn.delay(25, 3, "testy");
  });

  asyncTest("#defer", 1, function() {
    var fn;
    fn = function(x) {
      equals(x, 3);
      return start();
    };
    return fn.defer(3);
  });

  module();

}).call(this);
(function() {

  module("Logging");

  test("log exists", function() {
    return ok(log);
  });

  module();

}).call(this);
(function() {

  (function() {
    var TOLERANCE, equalEnough, matrixEqual;
    module("Matrix");
    TOLERANCE = 0.00001;
    equalEnough = function(expected, actual, tolerance, message) {
      message || (message = "" + expected + " within " + tolerance + " of " + actual);
      return ok(expected + tolerance >= actual && expected - tolerance <= actual, message);
    };
    matrixEqual = function(m1, m2) {
      equalEnough(m1.a, m2.a, TOLERANCE);
      equalEnough(m1.b, m2.b, TOLERANCE);
      equalEnough(m1.c, m2.c, TOLERANCE);
      equalEnough(m1.d, m2.d, TOLERANCE);
      equalEnough(m1.tx, m2.tx, TOLERANCE);
      return equalEnough(m1.ty, m2.ty, TOLERANCE);
    };
    test("copy constructor", function() {
      var matrix, matrix2;
      matrix = Matrix(1, 0, 0, 1, 10, 12);
      matrix2 = Matrix(matrix);
      ok(matrix !== matrix2);
      return matrixEqual(matrix2, matrix);
    });
    test("Matrix() (Identity)", function() {
      var matrix;
      matrix = Matrix();
      equals(matrix.a, 1, "a");
      equals(matrix.b, 0, "b");
      equals(matrix.c, 0, "c");
      equals(matrix.d, 1, "d");
      equals(matrix.tx, 0, "tx");
      equals(matrix.ty, 0, "ty");
      return matrixEqual(matrix, Matrix.IDENTITY);
    });
    test("Empty", function() {
      var matrix;
      matrix = Matrix(0, 0, 0, 0, 0, 0);
      equals(matrix.a, 0, "a");
      equals(matrix.b, 0, "b");
      equals(matrix.c, 0, "c");
      equals(matrix.d, 0, "d");
      equals(matrix.tx, 0, "tx");
      return equals(matrix.ty, 0, "ty");
    });
    test("#copy", function() {
      var copyMatrix, matrix;
      matrix = Matrix(2, 0, 0, 2);
      copyMatrix = matrix.copy();
      matrixEqual(copyMatrix, matrix);
      copyMatrix.a = 4;
      equals(copyMatrix.a, 4);
      return equals(matrix.a, 2, "Old 'a' value is unchanged");
    });
    test(".scale", function() {
      var matrix;
      matrix = Matrix.scale(2, 2);
      equals(matrix.a, 2, "a");
      equals(matrix.b, 0, "b");
      equals(matrix.c, 0, "c");
      equals(matrix.d, 2, "d");
      matrix = Matrix.scale(3);
      equals(matrix.a, 3, "a");
      equals(matrix.b, 0, "b");
      equals(matrix.c, 0, "c");
      return equals(matrix.d, 3, "d");
    });
    test(".scale (about a point)", function() {
      var p, transformedPoint;
      p = Point(5, 17);
      transformedPoint = Matrix.scale(3, 7, p).transformPoint(p);
      equals(transformedPoint.x, p.x, "Point should remain the same");
      return equals(transformedPoint.y, p.y, "Point should remain the same");
    });
    test("#scale (about a point)", function() {
      var p, transformedPoint;
      p = Point(3, 11);
      transformedPoint = Matrix.IDENTITY.scale(3, 7, p).transformPoint(p);
      equals(transformedPoint.x, p.x, "Point should remain the same");
      return equals(transformedPoint.y, p.y, "Point should remain the same");
    });
    test("#skew", function() {
      var matrix;
      matrix = Matrix();
      matrix = matrix.skew(0.125.turns, 0);
      return equals(matrix.c, Math.tan(0.125.turns));
    });
    test(".rotation", function() {
      var matrix;
      matrix = Matrix.rotation(Math.PI / 2);
      equalEnough(matrix.a, 0, TOLERANCE);
      equalEnough(matrix.b, 1, TOLERANCE);
      equalEnough(matrix.c, -1, TOLERANCE);
      return equalEnough(matrix.d, 0, TOLERANCE);
    });
    test(".rotation (about a point)", function() {
      var p, transformedPoint;
      p = Point(11, 7);
      transformedPoint = Matrix.rotation(Math.PI / 2, p).transformPoint(p);
      equals(transformedPoint.x, p.x, "Point should remain the same");
      return equals(transformedPoint.y, p.y, "Point should remain the same");
    });
    test("#rotate (about a point)", function() {
      var p, transformedPoint;
      p = Point(8, 5);
      transformedPoint = Matrix.IDENTITY.rotate(Math.PI / 2, p).transformPoint(p);
      equals(transformedPoint.x, p.x, "Point should remain the same");
      return equals(transformedPoint.y, p.y, "Point should remain the same");
    });
    test("#inverse (Identity)", function() {
      var matrix;
      matrix = Matrix().inverse();
      equals(matrix.a, 1, "a");
      equals(matrix.b, 0, "b");
      equals(matrix.c, 0, "c");
      equals(matrix.d, 1, "d");
      equals(matrix.tx, 0, "tx");
      return equals(matrix.ty, 0, "ty");
    });
    test("#concat", function() {
      var matrix;
      matrix = Matrix.rotation(Math.PI / 2).concat(Matrix.rotation(-Math.PI / 2));
      return matrixEqual(matrix, Matrix.IDENTITY);
    });
    test("#toString", function() {
      var matrix;
      matrix = Matrix(0.5, 2, 0.5, -2, 3, 4.5);
      return matrixEqual(eval(matrix.toString()), matrix);
    });
    test("Maths", function() {
      var a, b, c;
      a = Matrix(12, 3, 3, 1, 7, 9);
      b = Matrix(3, 8, 3, 2, 1, 5);
      c = a.concat(b);
      equals(c.a, 60);
      equals(c.b, 17);
      equals(c.c, 42);
      equals(c.d, 11);
      equals(c.tx, 34);
      return equals(c.ty, 17);
    });
    test("Order of transformations should match manual concat", function() {
      var m1, m2, s, theta, tx, ty;
      tx = 10;
      ty = 5;
      theta = Math.PI / 3;
      s = 2;
      m1 = Matrix().translate(tx, ty).scale(s).rotate(theta);
      m2 = Matrix().concat(Matrix.translation(tx, ty)).concat(Matrix.scale(s)).concat(Matrix.rotation(theta));
      return matrixEqual(m1, m2);
    });
    test("IDENTITY is immutable", function() {
      var identity;
      identity = Matrix.IDENTITY;
      identity.a = 5;
      return equals(identity.a, 1);
    });
    return module(void 0);
  })();

}).call(this);
(function() {
  var equalEnough;

  equalEnough = function(expected, actual, tolerance, message) {
    message || (message = "" + expected + " within " + tolerance + " of " + actual);
    return ok(expected + tolerance >= actual && expected - tolerance <= actual, message);
  };

  module("Number");

  test("#abs", function() {
    equals(5..abs(), 5, "(5).abs() equals 5");
    equals(4.2.abs(), 4.2, "(4.2).abs() equals 4.2");
    equals((-1.2).abs(), 1.2, "(-1.2).abs() equals 1.2");
    return equals(0..abs(), 0, "(0).abs() equals 0");
  });

  test("#ceil", function() {
    equals(4.9.ceil(), 5, "(4.9).floor() equals 5");
    equals(4.2.ceil(), 5, "(4.2).ceil() equals 5");
    equals((-1.2).ceil(), -1, "(-1.2).ceil() equals -1");
    return equals(3..ceil(), 3, "(3).ceil() equals 3");
  });

  test("#clamp", function() {
    equals(5..clamp(0, 3), 3);
    equals(5..clamp(-1, 0), 0);
    equals((-5).clamp(0, 1), 0);
    equals(1..clamp(0, null), 1);
    equals((-1).clamp(0, null), 0);
    equals((-10).clamp(-5, 0), -5);
    equals((-10).clamp(null, 0), -10);
    return equals(50..clamp(null, 10), 10);
  });

  test("#floor", function() {
    equals(4.9.floor(), 4, "(4.9).floor() equals 4");
    equals(4.2.floor(), 4, "(4.2).floor() equals 4");
    equals((-1.2).floor(), -2, "(-1.2).floor() equals -2");
    return equals(3..floor(), 3, "(3).floor() equals 3");
  });

  test("#round", function() {
    equals(4.5.round(), 5, "(4.5).round() equals 5");
    return equals(4.4.round(), 4, "(4.4).round() equals 4");
  });

  test("#sign", function() {
    equals(5..sign(), 1, "Positive number's sign is 1");
    equals((-3).sign(), -1, "Negative number's sign is -1");
    return equals(0..sign(), 0, "Zero's sign is 0");
  });

  test("#even", function() {
    [0, 2, -32].each(function(n) {
      return ok(n.even(), "" + n + " is even");
    });
    return [1, -1, 2.2, -3.784].each(function(n) {
      return equals(n.even(), false, "" + n + " is not even");
    });
  });

  test("#odd", function() {
    [1, 9, -37].each(function(n) {
      return ok(n.odd(), "" + n + " is odd");
    });
    return [0, 32, 2.2, -1.1].each(function(n) {
      return equals(n.odd(), false, "" + n + " is not odd");
    });
  });

  test("#times", function() {
    var n;
    n = 5;
    return equals(n.times(function() {}), n, "returns n");
  });

  test("#times called correct amount", function() {
    var count, n;
    n = 5;
    count = 0;
    n.times(function() {
      return count++;
    });
    return equals(n, count, "returns n");
  });

  test("#constrainRotation", function() {
    equals((Math.PI * 5).constrainRotation(), Math.PI);
    equals((-Math.PI * 5).constrainRotation(), -Math.PI);
    equals((Math.TAU / 4 * 5).constrainRotation(), Math.TAU / 4);
    return equals((Math.TAU / 4 * 3).constrainRotation(), -Math.TAU / 4);
  });

  test("#mod should have a positive result when used with a positive base and a negative number", function() {
    var n;
    n = -3;
    return equals(n.mod(8), 5, "Should 'wrap' and be positive.");
  });

  test("#primeFactors", function() {
    var factors;
    factors = 15..primeFactors();
    equals(factors.length, 2);
    equals(factors[0], 3);
    equals(factors[1], 5);
    equals(factors.product(), 15);
    factors = 256..primeFactors();
    equals(factors.product(), 256);
    equals(factors.length, 8);
    equals(factors.first(), 2);
    equals(factors.last(), 2);
    factors = 997..primeFactors();
    equals(factors.length, 1);
    equals(factors.first(), 997);
    equals(factors.product(), 997);
    equals(0..primeFactors(), void 0);
    factors = (-3).primeFactors();
    equals(factors.first(), -1);
    return equals(factors.product(), -3);
  });

  test("#seconds", function() {
    equals(1..second, 1000);
    return equals(3..seconds, 3000);
  });

  test("#degrees", function() {
    equals(180..degrees, Math.PI);
    return equals(1..degree, Math.TAU / 360);
  });

  test("#rotations", function() {
    equals(1..rotation, Math.TAU);
    return equals(0.5.rotations, Math.TAU / 2);
  });

  test("#turns", function() {
    equals(1..turn, Math.TAU);
    return equals(0.5.turns, Math.TAU / 2);
  });

  test("#circularPoints", function() {
    var points;
    points = [Point(1, 0), Point(0, 1), Point(-1, 0), Point(0, -1)];
    return 4..circularPoints(function(p, i) {
      equalEnough(p.x, points[i].x, 0.001);
      return equalEnough(p.y, points[i].y, 0.001);
    });
  });

  module(void 0);

}).call(this);
(function() {

  module("Object");

  test("isArray", function() {
    var array, number, object, string;
    array = [1, 2, 3];
    object = {
      blah: "blah",
      second: "another"
    };
    number = 5;
    string = "string";
    ok(Object.isArray(array), "an array is an array");
    ok(!Object.isArray(object), "an object is not an array");
    ok(!Object.isArray(number), "a number is not an array");
    return ok(!Object.isArray(string), "a string is not array");
  });

  test("isString", function() {
    ok(Object.isString("a string"), "'a string' is a string");
    ok(!Object.isString([1, 2, 4]), "an array is not a string");
    return ok(!Object.isString({
      key: "value"
    }), "an object literal is not a string");
  });

  test("reverseMerge", function() {
    var object;
    object = {
      test: true,
      b: "b"
    };
    Object.reverseMerge(object, {
      test: false,
      c: "c"
    });
    ok(object.test);
    return equals(object.c, "c");
  });

  test("extend", function() {
    var object;
    object = {
      test: true,
      b: "b"
    };
    Object.extend(object, {
      test: false,
      c: "c"
    });
    equals(object.test, false);
    equals(object.b, "b");
    return equals(object.c, "c");
  });

  test("isObject", function() {
    var object;
    object = {};
    return equals(Object.isObject(object), true);
  });

  module();

}).call(this);
(function() {

  (function() {
    var TOLERANCE, equalEnough;
    module("Point");
    TOLERANCE = 0.00001;
    equalEnough = function(expected, actual, tolerance, message) {
      message || (message = "" + expected + " within " + tolerance + " of " + actual);
      return ok(expected + tolerance >= actual && expected - tolerance <= actual, message);
    };
    test("copy constructor", function() {
      var p, p2;
      p = Point(3, 7);
      p2 = Point(p);
      equals(p2.x, p.x);
      return equals(p2.y, p.y);
    });
    test("#add", function() {
      var p1, p2, result;
      p1 = Point(5, 6);
      p2 = Point(7, 5);
      result = p1.add(p2);
      equals(result.x, p1.x + p2.x);
      equals(result.y, p1.y + p2.y);
      equals(p1.x, 5);
      equals(p1.y, 6);
      equals(p2.x, 7);
      return equals(p2.y, 5);
    });
    test("#add with two arguments", function() {
      var point, result, x, y;
      point = Point(3, 7);
      x = 2;
      y = 1;
      result = point.add(x, y);
      equals(result.x, point.x + x);
      equals(result.y, point.y + y);
      x = 2;
      y = 0;
      result = point.add(x, y);
      equals(result.x, point.x + x);
      return equals(result.y, point.y + y);
    });
    test("#add$", function() {
      var p;
      p = Point(0, 0);
      p.add$(Point(3, 5));
      equals(p.x, 3);
      equals(p.y, 5);
      p.add$(2, 1);
      equals(p.x, 5);
      return equals(p.y, 6);
    });
    test("#subtract", function() {
      var p1, p2, result;
      p1 = Point(5, 6);
      p2 = Point(7, 5);
      result = p1.subtract(p2);
      equals(result.x, p1.x - p2.x);
      return equals(result.y, p1.y - p2.y);
    });
    test("#subtract$", function() {
      var p;
      p = Point(8, 6);
      p.subtract$(3, 4);
      equals(p.x, 5);
      return equals(p.y, 2);
    });
    test("#norm", function() {
      var normal, p;
      p = Point(2, 0);
      normal = p.norm();
      equals(normal.x, 1);
      normal = p.norm(5);
      equals(normal.x, 5);
      p = Point(0, 0);
      normal = p.norm();
      equals(normal.x, 0, "x value of norm of point(0,0) is 0");
      return equals(normal.y, 0, "y value of norm of point(0,0) is 0");
    });
    test("#norm$", function() {
      var p;
      p = Point(6, 8);
      p.norm$(5);
      equals(p.x, 3);
      return equals(p.y, 4);
    });
    test("#scale", function() {
      var p, result, scalar;
      p = Point(5, 6);
      scalar = 2;
      result = p.scale(scalar);
      equals(result.x, p.x * scalar);
      equals(result.y, p.y * scalar);
      equals(p.x, 5);
      return equals(p.y, 6);
    });
    test("#scale$", function() {
      var p, scalar;
      p = Point(0, 1);
      scalar = 3;
      p.scale$(scalar);
      equals(p.x, 0);
      return equals(p.y, 3);
    });
    test("#floor", function() {
      var p1;
      p1 = Point(7.2, 6.9);
      return ok(Point(7, 6).equal(p1.floor()));
    });
    test("#floor$", function() {
      var p1;
      p1 = Point(7.2, 6.9);
      p1.floor$();
      return ok(Point(7, 6).equal(p1));
    });
    test("#equal", function() {
      return ok(Point(7, 8).equal(Point(7, 8)));
    });
    test("#magnitude", function() {
      return equals(Point(3, 4).magnitude(), 5);
    });
    test("#length", function() {
      equals(Point(0, 0).length(), 0);
      return equals(Point(-1, 0).length(), 1);
    });
    test("#toString", function() {
      var p;
      p = Point(7, 5);
      return ok(eval(p.toString()).equal(p));
    });
    test("#clamp", function() {
      var p, p2;
      p = Point(10, 10);
      p2 = p.clamp(5);
      return equals(p2.length(), 5);
    });
    test(".centroid", function() {
      var centroid;
      centroid = Point.centroid(Point(0, 0), Point(10, 10), Point(10, 0), Point(0, 10));
      equals(centroid.x, 5);
      return equals(centroid.y, 5);
    });
    test(".fromAngle", function() {
      var p;
      p = Point.fromAngle(Math.TAU / 4);
      equalEnough(p.x, 0, TOLERANCE);
      return equals(p.y, 1);
    });
    test(".random", function() {
      var p;
      p = Point.random();
      return ok(p);
    });
    test(".interpolate", function() {
      var p1, p2;
      p1 = Point(10, 7);
      p2 = Point(-6, 29);
      ok(p1.equal(Point.interpolate(p1, p2, 0)));
      return ok(p2.equal(Point.interpolate(p1, p2, 1)));
    });
    test("ZERO is immutable", function() {
      var zero;
      zero = Point.ZERO;
      zero.x = 5;
      zero.y = 2;
      equals(zero.x, 0);
      return equals(zero.y, 0);
    });
    return module(void 0);
  })();

}).call(this);
(function() {

  module("Random");

  test("methods", function() {
    ok(Random.angle);
    ok(Random.often);
    return ok(Random.sometimes);
  });

  test("Global rand", function() {
    var f, n;
    n = rand(2);
    ok(n === 0 || n === 1, "rand(2) gives 0 or 1");
    f = rand();
    return ok(f <= 1 || f >= 0, "rand() gives numbers between 0 and 1");
  });

  test(".angleBetween", function() {
    var a;
    ok(Random.angleBetween);
    a = Random.angleBetween(0.25.turns, 0.5.turns);
    ok(a < 0.5.turns);
    return ok(a > 0.25.turns);
  });

  module();

}).call(this);
(function() {

  module("Rectangle");

  test("getter for left calculates correctly", function() {
    var rect;
    rect = Rectangle({
      x: 2,
      y: 30,
      width: 2,
      height: 49
    });
    return equals(rect.left, 2);
  });

  test("getter for right calculates correctly", function() {
    var rect;
    rect = Rectangle({
      x: 10,
      y: 15,
      width: 5,
      height: 20
    });
    return equals(rect.right, 15);
  });

  test("getter for top calculates correctly", function() {
    var rect;
    rect = Rectangle({
      x: 3,
      y: 4,
      width: 5,
      height: 6
    });
    return equals(rect.top, 4);
  });

  test("getter for bottom calculates correctly", function() {
    var rect;
    rect = Rectangle({
      x: 20,
      y: 5,
      width: 25,
      height: 30
    });
    return equals(rect.bottom, 35);
  });

  test("#center", function() {
    var rect;
    rect = Rectangle({
      x: 23,
      y: 21,
      width: 10,
      height: 4
    });
    return ok(rect.center().equal(Point(28, 23)));
  });

  test("#equal", function() {
    var rect1, rect2, rect3;
    rect1 = Rectangle({
      x: 9,
      y: 3,
      width: 7,
      height: 4
    });
    rect2 = Rectangle({
      x: 4,
      y: 3,
      width: 8,
      height: 2
    });
    rect3 = Rectangle({
      x: 9,
      y: 3,
      width: 7,
      height: 4
    });
    ok(!rect1.equal(rect2));
    return ok(rect1.equal(rect3));
  });

  module();

}).call(this);
(function() {

  module("String");

  test("#blank", function() {
    equals("  ".blank(), true, "A string containing only whitespace should be blank");
    equals("a".blank(), false, "A string that contains a letter should not be blank");
    equals("  a ".blank(), false);
    return equals("  \n\t ".blank(), true);
  });

  test("#camelize", function() {
    return equals("active_record".camelize(), "activeRecord");
  });

  test("#constantize", function() {
    equals("String".constantize(), String, "look up a constant");
    equals("Math".constantize(), Math, "look up a constant");
    equals("Number".constantize(), Number, "look up a constant");
    return equals("Math.TAU".constantize(), Math.TAU, "namespaced constants work too");
  });

  test("#extension", function() {
    equals("README".extension(), "");
    equals("README.md".extension(), "md");
    equals("jquery.min.js".extension(), "js");
    return equals("src/bouse.js.coffee".extension(), "coffee");
  });

  test("#humanize", function() {
    return equals("employee_salary".humanize(), "Employee salary");
  });

  test("isString", function() {
    var _base, _base1;
    equals(typeof "".isString === "function" ? "".isString() : void 0, true, "Strings are strings");
    equals(typeof (_base = {}).isString === "function" ? _base.isString() : void 0, void 0, "objects are not strings");
    return equals(typeof (_base1 = []).isString === "function" ? _base1.isString() : void 0, void 0, "arrays are not strings");
  });

  test("#parse", function() {
    equals("true".parse(), true, "parsing 'true' should equal boolean true");
    equals("false".parse(), false, "parsing 'true' should equal boolean true");
    equals("7.2".parse(), 7.2, "numbers should be cool too");
    equals('{"val": "a string"}'.parse().val, "a string", "even parsing objects works");
    return ok(''.parse() === '', "Empty string parses to exactly the empty string");
  });

  test("#startsWith", function() {
    ok("cool".startsWith("coo"));
    return equals("cool".startsWith("oo"), false);
  });

  test("#titleize", function() {
    equals("man from the boondocks".titleize(), "Man From The Boondocks");
    return equals("x-men: the last stand".titleize(), "X Men: The Last Stand");
  });

  test("#underscore", function() {
    equals("Pro-tip".underscore(), "pro_tip");
    equals("Bullet".underscore(), "bullet");
    return equals("FPSCounter".underscore(), "fps_counter");
  });

  test("#withoutExtension", function() {
    equals("neat.png".withoutExtension(), "neat");
    return equals("not a file".withoutExtension(), "not a file");
  });

  module();

}).call(this);
(function() {



}).call(this);
