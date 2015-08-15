# Description:
#   Handle polls
#
# Dependencies:
#   Moment-timezone.js
#
# Configuration:
#
# Commands:
#   hubot start poll [topic] {option:[option]}
#   hubot vote [#option]
# Author:
#   logikz
class Option
    constructor: () ->
class Poll
    constructor: () ->

module.exports = (robot) ->
    robot.respond /start poll (.*?)\s(option:\s?.*)+/i, (msg) ->
        try
            @robot.logger.info "Create poll called: #{msg}"
            topic = msg.match[1]
            #@robot.logger.info "Topic: #{topic}"
            options = msg.match[2]
            room = msg.message.room
            #@robot.logger.info "options: #{options}"           
            @robot.logger.info "Creating poll with #{topic}"            
            
            pollOptions = (options.split "option: ")[1..]
            @robot.brain.data.poll[room] = new Poll()
            @robot.logger.info "Poll init complete"
            @robot.brain.data.poll[room].topic = topic          
            @robot.logger.info "Poll added topic"
            optionsString = ""

            @robot.brain.data.poll[room].options = {}
            for pollOption in pollOptions
                index = pollOptions.indexOf(pollOption)
                @robot.brain.data.poll[room].options[index] = new Option()
                @robot.brain.data.poll[room].options[index].text = pollOption
                optionsString += "\t#{index}: #{pollOption}\n"
            @robot.brain.save()
            @robot.logger.info "Brain saved"

            text =  """                 
                    Topic: #{topic}
                    Options:
                    #{optionsString}
                    """
            msg.send "#{text}"
        catch error
            msg.send error
            @robot.logger.error error

    robot.respond /vote\s+(\d+)/i, (msg) ->
        try     
            vote = msg.match[1]
            user = msg.envelope.user['name']
            room = msg.message.room
            options = @robot.brain.data.poll[room].options
            @robot.logger.info "Adding new vote for #{@robot.brain.data.poll[room].topic} with #{Object.keys(options).length} options"
            if vote >= Object.keys(options).length
                @robot.logger.info "Invalid vote. #{vote} >= #{Object.keys(options).length}"
                msg.reply "Please vote for a valid option"
                return
            #check if the user already voted
            @robot.logger.info "Adding a vote for #{vote} for #{user}"
            for index, option of options
                @robot.logger.info "Checking #{index}: #{option.text}"
                if option.users != undefined
                    @robot.logger.info "Some have voted for this one"
                    option.users = option.users.filter (currentUser) -> currentUser isnt user
            @robot.logger.info "Finishes removing user"
            selectedOption = @robot.brain.data.poll[room].options[vote]
            if selectedOption.users != undefined
                @robot.logger.info "add user to this option since it's defined"
                selectedOption.users.push(user)
            else
                @robot.logger.info "First vote, create new array"
                selectedOption.users = []
                selectedOption.users.push(user)
            @robot.brain.save()
            @robot.logger.info "Brain saved"
            msg.reply "Thanks for your vote"
        catch error
            @robot.logger.error error

    robot.respond /vote\s+(\d+,?)/i, (msg) ->
        try
            votes = msg.match[1]
            user = msg.envelope.user['name']
            room = msg.message.room
            options = @robot.brain.data.poll[room].options
            @robot.logger.info "Adding new vote for #{@robot.brain.data.poll[room].topic} with #{Object.keys(options).length} options"

            #check if the user already voted
            @robot.logger.info "Adding a vote for #{vote} for #{user}"
            for index, option of options
                @robot.logger.info "Checking #{index}: #{option.text}"
                if option.users != undefined
                    @robot.logger.info "Some have voted for this one"
                    option.users = option.users.filter (currentUser) -> currentUser isnt user
            
            @robot.logger.info "Finishes removing user"
            votes = votes.split(",")
            for(i = 0; i < votes.length; ++i){
                vote = votes[i]
                if vote >= Object.keys(options).length
                    @robot.logger.info "Invalid vote. #{vote} >= #{Object.keys(options).length}"
                    msg.reply "Please vote for a valid option"
                    return

                selectedOption = @robot.brain.data.poll[room].options[vote]
                if selectedOption.users != undefined
                    @robot.logger.info "add user to this option since it's defined"
                    selectedOption.users.push(user)
                else
                    @robot.logger.info "First vote, create new array"
                    selectedOption.users = []
                    selectedOption.users.push(user)                
            }

            @robot.brain.save()
            @robot.logger.info "Brain saved"
            msg.reply "Thanks for your vote"
        catch error
            @robot.logger.error error

    robot.respond /(view|show|poll) result(s)?/i, (msg) ->
        try
            @robot.logger.info "View results"
            room = msg.message.room
            topic = @robot.brain.data.poll[room].topic      
            options = @robot.brain.data.poll[room].options
            optionString = ""
            for index, option of options
                text = option.text
                userString = ""
                numVotes = 0
                if option.users != undefined 
                    option.users.length
                    numVotes = option.users.length
                    users = option.users
                    userString = "Users:(#{users.join(", ")})"
                @robot.logger.info "option: #{option} :: text: #{text} :: count: #{numVotes} :: users: userString"
                optionString += "\t#{index}: #{text} Total: #{numVotes} #{userString}\n"
            msg.send """
            #{topic}
            Current Poll Results:
            #{optionString}
            """
        catch error
            @robot.logger.error error


