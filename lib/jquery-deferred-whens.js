(function() {
    /*
    *
    *   jquery-deferred-whens.coffee/jquery-deferred-whens.js
    *   Copyright 2011 Francois Lafortune, @quickredfox
    *   Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
    *  
    */
    var whenNone, whenOne, whenSome, _promise, _when;
    if (!jQuery.Deferred) {
      throw "Your version of jQuery does not contain the $.Deferred() implementation.";
    }
    _promise = function(values) {
      return values.map(function(value) {
        return jQuery.when(value);
      });
    };
    _when = function(promise, method, data, callback) {
      return promise[method](function() {
        return callback(Array.prototype.slice.call(arguments).reduce(function(all, one) {
          all.push(one);
          return all;
        }, data));
      });
    };
    whenSome = function(promises, results, errors, terminal) {
      var promise;
      if (promises == null) {
        promises = [];
      }
      if (results == null) {
        results = [];
      }
      if (errors == null) {
        errors = [];
      }
      if (terminal == null) {
        terminal = jQuery.Deferred();
      }
      if (promises.length === 0) {
        if (results.length > 0) {
          return terminal.resolveWith(null, results);
        } else {
          return terminal.rejectWith(null, errors);
        }
      }
      promise = promises.shift();
      _when(promise, 'fail', errors, function() {
        return whenSome(promises, results, errors, terminal);
      });
      _when(promise, 'done', results, function() {
        return whenSome(promises, results, errors, terminal);
      });
      return terminal.promise();
    };
    whenOne = function(promises, results, errors, terminal) {
      var promise;
      if (promises == null) {
        promises = [];
      }
      if (results == null) {
        results = [];
      }
      if (errors == null) {
        errors = [];
      }
      if (terminal == null) {
        terminal = jQuery.Deferred();
      }
      if (promises.length === 0) {
        if (results.length > 0) {
          return terminal.resolveWith(null, results);
        } else {
          return terminal.rejectWith(null, errors);
        }
      }
      promise = promises.shift();
      _when(promise, 'fail', errors, function(errors) {
        return whenOne(promises, results, errors, terminal);
      });
      _when(promise, 'done', results, function(results) {
        return terminal.resolveWith(null, results);
      });
      return terminal.promise();
    };
    whenNone = function(promises, results, errors, terminal) {
      var promise;
      if (promises == null) {
        promises = [];
      }
      if (results == null) {
        results = [];
      }
      if (errors == null) {
        errors = [];
      }
      if (terminal == null) {
        terminal = jQuery.Deferred();
      }
      if (promises.length === 0) {
        if (results.length > 0) {
          return terminal.rejectWith(null, results);
        } else {
          return terminal.resolveWith(null, errors);
        }
      }
      promise = promises.shift();
      _when(promise, 'fail', errors, function(errors) {
        return whenNone(promises, results, errors, terminal);
      });
      _when(promise, 'done', results, function(results) {
        return whenNone(promises, results, errors, terminal);
      });
      return terminal.promise();
    };
    /*
        jQuery.whenSome( deferred [, deferred, deferred, deferred, ... ] )
        returns a promise that is resolved when at least some of the deferreds 
        are succeful otherwise rejected if no successes were encoutered
    */
    jQuery.whenSome = function() {
      return whenSome(_promise(Array.prototype.slice.call(arguments)));
    };
    /*
        jQuery.whenNone( deferred [, deferred, deferred, deferred, ... ] )
        returns a promise that is resolved when at none of the deferreds 
        are succeful otherwise rejected if a success was encountered
    */
    jQuery.whenNone = function() {
      return whenNone(_promise(Array.prototype.slice.call(arguments)));
    };
    /*
        jQuery.whenOne( deferred [, deferred, deferred, deferred, ... ] )
        returns a promise that is resolved on the first succesful
        deferred otherwise rejected if none were successful
    */
    jQuery.whenOne = function() {
      return whenOne(_promise(Array.prototype.slice.call(arguments)));
    };
    /*
        jQuery.whenAll( deferred [, deferred, deferred, deferred, ... ] )
        returns a promise that is resolved when all promises are successful
        otherwise rejected on first failure.
        nb: Sames as jQuery.when but supports whenSome's arguments structure
    */
    jQuery.whenAll = function() {
      return jQuery.when.apply(jQuery.Deferred, Array.prototype.slice.call(arguments));
    };
}).call(this);
