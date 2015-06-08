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
Please enjoy the use of our ingress bot - Tardis.  You can type ```tardis help``` for command usage.  
Please only use tardis in random or in private message directly to Tardis.  He can be quite the talker :). 
Feel free to make public and private chat rooms to discuss various topics.

One cool thing tardis does is remember your badges, if you visit http://enlightened.la/badges/ you can select the badges you have and use the provided text to let @tardis know which badges you have.

If you need any help, feel free to message The82ndDoctor
'''

module.exports = (robot) ->
	robot.enter (msg)->
		room = msg.message.room
		if(room == "general" or room == "random")
			msg.reply(welcomeMessage)
