###
*
*   jquery-deferred-whens.coffee/jquery-deferred-whens.js
*   Copyright 2011 Francois Lafortune, @quickredfox
*   Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
*  
###

if !jQuery.Deferred then throw "Your version of jQuery does not contain the $.Deferred() implementation."

_promise = (values)-> values.map ( value )-> jQuery.when value
            
_when = ( promise, method, data, callback)->
    promise[method] ()-> 
        callback Array::slice.call( arguments ).reduce ( all, one )-> 
            all.push( one ) # concat would create new copy.
            return all
        , data
    
whenSome = ( promises=[], results=[] , errors=[], terminal= jQuery.Deferred() )->
    if promises.length is 0
        if results.length > 0 then return terminal.resolveWith( null, results ) 
        else return terminal.rejectWith( null, errors )        
    promise  = promises.shift()
    _when promise, 'fail', errors,  ()-> whenSome promises, results, errors, terminal        
    _when promise, 'done', results, ()-> whenSome promises, results, errors, terminal
    return terminal.promise()

whenOne = ( promises=[], results=[] , errors=[], terminal= jQuery.Deferred() )->
    if promises.length is 0
        if results.length > 0 then return terminal.resolveWith( null, results ) 
        else return terminal.rejectWith( null, errors )
    promise = promises.shift()
    _when promise, 'fail', errors,  ( errors )-> whenOne promises, results, errors, terminal
    _when promise, 'done', results, ( results)-> terminal.resolveWith null, results
    return terminal.promise()

whenNone = ( promises=[], results=[] , errors=[], terminal= jQuery.Deferred() )->
    if promises.length is 0
        if results.length > 0 then return terminal.rejectWith( null, results ) 
        else return terminal.resolveWith( null, errors )
    promise = promises.shift()
    _when promise, 'fail', errors,  ( errors )-> whenNone promises, results, errors, terminal
    _when promise, 'done', results, ( results)-> whenNone promises, results, errors, terminal
    return terminal.promise()

###
    jQuery.whenSome( deferred [, deferred, deferred, deferred, ... ] )
    returns a promise that is resolved when at least some of the deferreds 
    are succeful otherwise rejected if no successes were encoutered
###

jQuery.whenSome=-> whenSome  _promise Array::slice.call(  arguments )

###
    jQuery.whenNone( deferred [, deferred, deferred, deferred, ... ] )
    returns a promise that is resolved when at none of the deferreds 
    are succeful otherwise rejected if a success was encountered
###

jQuery.whenNone=-> whenNone  _promise Array::slice.call( arguments )

###
    jQuery.whenOne( deferred [, deferred, deferred, deferred, ... ] )
    returns a promise that is resolved on the first succesful
    deferred otherwise rejected if none were successful
###

jQuery.whenOne=-> whenOne   _promise Array::slice.call(  arguments )

###
    jQuery.whenAll( deferred [, deferred, deferred, deferred, ... ] )
    returns a promise that is resolved when all promises are successful
    otherwise rejected on first failure.
    nb: Sames as jQuery.when but supports whenSome's arguments structure
###
jQuery.whenAll =-> jQuery.when.apply jQuery.Deferred, Array::slice.call(  arguments )
