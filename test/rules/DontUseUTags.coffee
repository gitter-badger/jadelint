expect = require('chai').expect
rule = require "./../../src/rules/#{require('path').basename(__filename, '.coffee')}"

describe 'DontUseUTags', ->
    it 'should catch any u element', ->
        expect rule::validate """
        u Some text
        """
        .to.be.false

    it 'should ignore other element types', ->
        expect rule::validate """
        div(type="text/css")
        """
        .to.be.true
