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
Welcome to Slack! :frog:  
Please enjoy the use of our ingress bot - Jarvis.  You can type ```jarvis help``` for command usage.  
Please only use jarvis in #general or #random.  He can be quite the talker :). 

If you need any help, feel free to message ITRogue.
'''

module.exports = (robot) ->
	robot.enter (msg)->
		room = msg.message.room
		if(room == "general" or room == "random" or room == "testchannel")
			msg.reply(welcomeMessage)

	leaveReplies = ['Was it something I said?', 
					'If I massage your feet, will you stay?', 
					'Good riddance!',
					'Kick rocks...chump!',
					'Quite frankly, your inadequacy was off putting... Have a nice life!',
					'Ciao!',
					'Hasta la vista, baby :sunglasses:',
					'Have fun storming the castle!',
					'And stay out!',
					'Exit, stage right!',
					'dun Dun DUUUN!',
					'Oh, running away, eh?']
	robot.leave (res) ->
      res.send res.random leaveReplies
