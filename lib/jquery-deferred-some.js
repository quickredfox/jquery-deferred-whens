(function() {
    var whenNone, whenOne, whenSome, _flatten, _promise, _when;
    _flatten = function(arr) {
      return arr.reduce((function(xs, el) {
        if (Array.isArray(el)) {
          return xs.concat(_flatten(el));
        } else {
          return xs.concat([el]);
        }
      }), []);
    };
    _promise = function(values) {
      return values.map(function(value) {
        return $.when(value);
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
    whenSome = function(promises, results, errors, final) {
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
      if (final == null) {
        final = $.Deferred();
      }
      if (promises.length === 0) {
        if (results.length > 0) {
          return final.resolveWith(null, results);
        } else {
          return final.rejectWith(null, errors);
        }
      }
      promise = promises.shift();
      _when(promise, 'fail', errors, function() {
        return whenSome(promises, results, errors, final);
      });
      _when(promise, 'done', results, function() {
        return whenSome(promises, results, errors, final);
      });
      return final.promise();
    };
    whenOne = function(promises, results, errors, final) {
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
      if (final == null) {
        final = $.Deferred();
      }
      if (promises.length === 0) {
        if (results.length > 0) {
          return final.resolveWith(null, results);
        } else {
          return final.rejectWith(null, errors);
        }
      }
      promise = promises.shift();
      _when(promise, 'fail', errors, function(errors) {
        return whenOne(promises, results, errors, final);
      });
      _when(promise, 'done', results, function(results) {
        return final.resolveWith(null, results);
      });
      return final.promise();
    };
    whenNone = function(promises, results, errors, final) {
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
      if (final == null) {
        final = $.Deferred();
      }
      if (promises.length === 0) {
        if (results.length > 0) {
          return final.rejectWith(null, results);
        } else {
          return final.resolveWith(null, errors);
        }
      }
      promise = promises.shift();
      _when(promise, 'fail', errors, function(errors) {
        return whenNone(promises, results, errors, final);
      });
      _when(promise, 'done', results, function(results) {
        return whenNone(promises, results, errors, final);
      });
      return final.promise();
    };
    /*
        $.whenSome( deferred [, deferred, deferred, deferred, ... ] )
        returns a promise that is resolved when at least some of the deferreds 
        are succeful otherwise rejected if no successes were encoutered
    */
    $.whenSome = function() {
      return whenSome(_promise(_flatten(Array.prototype.slice.call(arguments))));
    };
    /*
        $.whenNone( deferred [, deferred, deferred, deferred, ... ] )
        returns a promise that is resolved when at none of the deferreds 
        are succeful otherwise rejected if a success was encountered
    */
    $.whenNone = function() {
      return whenNone(_promise(_flatten(Array.prototype.slice.call(arguments))));
    };
    /*
        $.whenOne( deferred [, deferred, deferred, deferred, ... ] )
        returns a promise that is resolved on the first succesful
        deferred otherwise rejected if none were successful
    */
    $.whenOne = function() {
      return whenOne(_promise(_flatten(Array.prototype.slice.call(arguments))));
    };
    /*
        $.whenAll( deferred [, deferred, deferred, deferred, ... ] )
        returns a promise that is resolved when all promises are successful
        otherwise rejected on first failure.
        nb: Sames as $.when but supports whenSome's arguments structure
    */
    $.whenAll = function() {
      return $.when.apply($.Deferred, _flatten(Array.prototype.slice.call(arguments)));
    };
}).call(this);
