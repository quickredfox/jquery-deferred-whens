# jQuery Deferred Whens

The idea is to offer conditional functionality on bundled promise evaluations into one logical deferred operation.

In other words, it provides functions similar to jQuery.when() for those times you don't necessarily need ALL your promises to pass.

## Usage 

Include either jquery-deferred-whens.js or jquery-deferred-whens.min.js in you page after jQuery
      <script src="http://code.jquery.com/jquery-1.6.4.min.js"></script>
      <script src="https://raw.github.com/quickredfox/jquery-deferred-whens/master/lib/jquery-deferred-whens.min.js"></script>

## API

Provides 4 methods `$.whenSome(), $.whenNone(), $.whenOne(), $.whenAll()`. 

Each of these methods expect one or more arguments. Each argument can be either a promise or any value.

The rest is pretty straight-forward: 

$.whenSome will resolve as done() if some of it's arguments have been successfully resolved, otherwise it will fail() if no values have passed.

$.whenNone will resolve as done() if none of it's arguments have been successfully resolved, otherwise it will fail() if one or more values have passed.

$.whenOne will resolve as done() as soon as one of it's values is successfully resolved, otherwise it will fail() if no values have passed.

$.whenAll Is pretty much the same as $.when but you can use null as the first value when you apply() multiple arguments.

NB: It is important to note that non-promised falsy values WILL resolve positively.

## $.whenSome() Pseudo-example


    function fetchGEOFromServiceA(){ ... returns a promise for users' GEO information ... };
    function fetchGEOFromServiceB(){ ... returns a promise for users' GEO information ... };
    function fetchGEOFromServiceC(){ ... returns a promise for users' GEO information ... };
    function fetchGEOFromServiceD(){ ... returns a promise for users' GEO information ... };
    var calls = [ 
        fetchGEOFromServiceA(), 
        fetchGEOFromServiceB(), 
        fetchGEOFromServiceC(), 
        fetchGEOFromServiceD() 
    ]
    var fetchSome = $.whenSome.apply( null, calls )
    
    /* now pretend fetchGEOFromServiceC() failed... */
    
    fetchSome.done( function( geoA, geoB, geoD ){
        /*
          Mix, match, merge, build a more complete GEO object
        */
    })
    fetchSome.fail( function(  ){ 
        /*
         Tell user he must be on moon or something.
        */
    })

----

jquery-deferred-whens.coffee and jquery-deferred-whens.js

Copyright 2011 Francois Lafortune, [@quickredfox](http://twitter.com/#!/quickredfox)

Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php


