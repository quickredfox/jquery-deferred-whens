  
GLOBAL.jQuery = require 'jquery'
require './jquery-deferred-some'

fastFailing = ()-> jQuery.Deferred().reject('fast fail').promise()
    
slowFailing = (time)->
    defer = jQuery.Deferred()
    setTimeout ()->
        defer.reject('slow fail')
    , time||333
    return defer.promise()
    
fastSuccess = ()-> jQuery.Deferred().resolve('fast').promise()

slowSuccess = (time)->
    defer = jQuery.Deferred()
    setTimeout ()->
        defer.resolve('slow')
    , time||333
    return defer.promise()
    
tenFails = ()->
    [0,1,2,3,4,5,6,7,8,9].reduce (all,i)->
        if i%2 then all.push( fastFailing() ) else all.push slowFailing(33)
        return all
    , []

tenSuccesses = ()->
    [0,1,2,3,4,5,6,7,8,9].reduce (all,i)->
        if i%2 then all.push( fastSuccess() ) else all.push( slowSuccess(33) )
        return all
    , []
    
twentyFailsAndSuccesses = ()->
    tenFails().concat( tenSuccesses() ).sort ()-> (Math.round(Math.random())-0.5)


###
    jQuery.whenSome
###
exports.whenSome=
    "With 10 failing promises and 10 successful promises": (test)->
        test.expect 1
        ref = jQuery.whenSome.apply( null, twentyFailsAndSuccesses() )
        ref.done ()->
            test.ok arguments.length is 10, "should be resolved as passing and contain 10 results"
            test.done()
        ref.fail ()->
            test.ok false, 'should not have been rejected'
            test.done()
        
    "With 10 failing promises": (test)->
        test.expect 1
        ref = jQuery.whenSome.apply( null, tenFails() )
        ref.done ()->
            test.ok false, "should not be successful"
            test.done()
        ref.fail ()->
            test.ok true, "should end up being rejected"
            test.done()

    "With 10 successful promises": (test)->
        test.expect 1
        ref = jQuery.whenSome.apply( null, tenSuccesses() )
        ref.done ()->
            test.ok true, "should end up being succesful"
            test.done()
        ref.fail ()->
            test.ok false, "should not be rejected"
            test.done()
        
    'With mixed arguments': (test)->
        test.expect 1
        ref = jQuery.whenSome( true, slowSuccess(), false, fastFailing(), null,  )
        ref.done ()->
            test.ok arguments.length is 4, "should end up being succesful with four results"
            test.done()
        ref.fail ()->
            test.ok false, "should not be rejected"
            test.done()
        
    'With 10 succesful non-promise arguments': (test)->
        test.expect 1
        f = ->
        ref = jQuery.whenSome( true, 'A', 0 , [1,2,3, [ false ] ], 'foo', undefined, jQuery, f , new Date(), {} )
        ref.done ()->
            test.ok arguments.length is 10, "should end up being succesful with 10 results"
            test.done()
        ref.fail ()->
            test.ok false, "should not be rejected"
            test.done()

###
    jQuery.whenNone
###
exports.whenNone=
    "With 10 failing promises and 10 successful promises": (test)->
        test.expect 1
        ref = jQuery.whenNone.apply( null, twentyFailsAndSuccesses() )
        ref.done ()->
            test.ok false, "should no be successful"        
            test.done()
        ref.fail ()->
            test.ok true, "should be rejected because some promises passed"        
            test.done()

    "With 10 failing promises and 10 successful promises (using apply)": (test)->
        test.expect 1
        ref = jQuery.whenNone.apply( null, twentyFailsAndSuccesses() )
        ref.done ()->
            test.ok false, "should no be successful"        
            test.done()
        ref.fail ()->
            test.ok true, "should be rejected because some promises passed"        
            test.done()

    "With 10 failing promises": (test)->
        test.expect 1
        ref = jQuery.whenNone.apply( null, tenFails() )
        ref.done ()->
            test.ok true, "should be successful"
            test.done()
        ref.fail ()->
            test.ok false, "should not be rejected"
            test.done()

    "With 10 successful promises": (test)->
        test.expect 1
        ref = jQuery.whenNone.apply( null, tenSuccesses() )
        ref.done ()->
            test.ok false, "should never be succesful"
            test.done()
        ref.fail ()->
            test.ok true, "should be rejected"
            test.done()

###
  jQuery.whenOne
###
exports.whenOne=
    "With 10 failing promises and 10 successful promises": (test)->
        test.expect 1
        ref = jQuery.whenOne.apply( null, twentyFailsAndSuccesses() )
        ref.done ()->
            test.ok arguments.length is 1, "should be succesful with one result"        
            test.done()
        ref.fail ()->
            test.ok false, "should not be rejected"        
            test.done()

    "With 10 failing promises": (test)->
        test.expect 1
        ref = jQuery.whenOne.apply( null, tenFails() )
        ref.done ()->
            test.ok false, "should not be successful"
            test.done()
        ref.fail ()->
            test.ok true, "should be rejected"
            test.done()

    "With 10 successful promises": (test)->
        test.expect 1
        ref = jQuery.whenOne.apply( null, tenSuccesses() )
        ref.done ()->
            test.ok arguments.length is 1, "should be succesful with only one result"
            test.done()
        ref.fail ()->
            test.ok false, "should not be rejected"
            test.done()
            
###
  jQuery.whenAll
###
exports.whenAll=

    "With 10 failing promises and 10 successful promises": (test)->
        test.expect 1
        ref = jQuery.whenAll.apply( null, twentyFailsAndSuccesses() )
        ref.done ()->
            test.ok false, "should not be succesful"        
            test.done()
        ref.fail ()->
            test.ok true, "should be rejected"        
            test.done()
            
    "With 10 failing promises": (test)->
        test.expect 1
        ref = jQuery.whenAll.apply( null, tenFails() )
        ref.done ()->
            test.ok false, "should not be succesful"        
            test.done()
        ref.fail ()->
            test.ok true, "should be rejected"        
            test.done()
            
    "With 10 successful promises": (test)->
        test.expect 1
        ref = jQuery.whenAll.apply( null, tenSuccesses() )
        ref.done ()->
            test.ok arguments.length is 10, "should be succesful with 10 results"        
            test.done()
        ref.fail ()->
            test.ok false, "should not be rejected"        
            test.done()

