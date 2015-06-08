# Description:
#   Entrance notifications
#
# Dependencies:

# Configuration:
#
# Commands:

# Author:
#   logikz

welcomeMessage = '''
Welcome to Slack! :allthethings:  
Please enjoy the use of our ingress bot - Jarvis.  You can type ```jarvis help``` for command usage.  
Please only use jarvis in general or in private message directly to Jarvis.  He can be quite the talker :). 
Feel free to make public and private chat rooms to discuss various topics.  

If you need any help, feel free to message Logikz
'''

module.exports = (robot) ->
	robot.enter (msg)->
		room = msg.message.room
		if(room == "general" or room == "tests")
			msg.reply(welcomeMessage)
