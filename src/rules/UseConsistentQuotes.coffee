Rule = require './../Rule'

firstUsed = undefined

class UseConsistentQuotes extends Rule
    name: 'Use consistent quotes for strings'
    level: 'ignore'
    description: """
    Make sure to use the same quote type for strings

    ```jade
    //- Invalid
    a(href="/api")
    a(href='/docs')

    //- Invalid
    p= 'whats up'
    a(href="/api")

    //- Valid
    p= 'hey there!'
    a(href='/api')
    ```
    """

    reset: ->
        firstUsed = undefined

    checkString: (str) ->
        if str.match /'[\s\S]*'/g
            console.log firstUsed
            if firstUsed is '"' then @fail() else firstUsed = "'"
        else if str.match /"[\s\S]*"/g
            if firstUsed is "'" then @fail() else firstUsed = '"'

    check: ->
        if @node.type is 'Tag'
            for {name, val} in @node.attrs
                console.log name, val
                @checkString val

module.exports = UseConsistentQuotes
