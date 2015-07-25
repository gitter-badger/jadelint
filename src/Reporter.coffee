chalk = require 'chalk'
symbol = require 'log-symbols'
table = require 'text-table'

class Reporter
    constructor: ->
        @errCount = 0
        @warnCount = 0
        @log = ''

    aggregate: (errors, filename) ->
        filename ?= errors[0]?.filename
        fileErrCount = 0
        fileWarnCount = 0

        errTable = table errors.filter((err) -> err.level isnt 'ignore').map (err) ->
            {level, name, filename, line} = err
            if level is 'error' then fileErrCount++
            if level is 'warning' then fileWarnCount++

            [
                ''
                symbol[level]
                chalk.grey "line #{line}"
                chalk.blue name
            ]

        if filename and fileErrCount > 0 or fileWarnCount > 0 then @log += "\n#{chalk.underline filename}\n" else ''
        @errCount += fileErrCount
        @warnCount += fileWarnCount
        @log += errTable
        @log += '\n'

    report: ->
        @log += '\n'

        if @warnCount > 0
            @log += chalk.yellow "#{symbol.warning}  #{@warnCount} warning#{if @warnCount isnt 1 then 's' else ''}\n"

        if @errCount > 0
            @log += chalk.red "#{symbol.error}  #{@errCount} warning#{if @errCount isnt 1 then 's' else ''}\n"

        if @errCount is 0 and @warnCount is 0
            @log += chalk.green "#{symbol.success} No problems found!\n"
            problems = false
        else
            problems = true

        console.log @log
        if problems then 1 else 0

module.exports = Reporter
