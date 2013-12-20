####################
### LOAD MODULES ###
####################

fs = require 'fs'

##############
### COLORS ###
##############

green = `'\033[0;32m'`
reset = `'\033[0m'`
red = `'\033[0;31m'`

################
### COMMANDS ###
################

commands = ['op', 'deop', 'voice', 'devoice']

########################
### GLOBAL VARIABLES ###
########################

cs = ""
isop = false
host = ""

##############
### MODULE ###
##############

module.exports = (client, config, i) ->

        # Set the command symbol to cs for easy use
        cs = config[i].commandSymbol

        # Add a config section for users if there isn't one
        if !config[i].users?
                config[i].users = {}
                updateConfig config
                
        # Listen for commands
        client.addListener 'message', (from, to, text, message) ->
                channel = message.args[0]
                msg = message.args[1]
                host = message.user + '@' + message.host

                # Check if the user exists
                if !config[i].users[from]?
                        config[i].users[from] = {}
                        updateConfig config

                # Check if the channel exists for the user
                if !config[i].users[from][channel]?
                        config[i].users[from][channel] = {}
                        config[i].users[from][channel].mode = ""
                        config[i].users[from][channel].host = host
                        updateConfig config

                # Check if the user is op or not
                isop = (config[i].users[from][channel].mode is '+o')
                isop = isop and (config[i].users[from][channel].host is host)
                
                # Check if the user said any of the commands
                op client, config, from, message if msg.indexOf(cs + 'op') is 0
                deop client, config, from, message if msg.indexOf(cs + 'deop') is 0
                voice client, config, from, message if msg.indexOf(cs + 'voice') is 0
                devoice client, config, from, message if msg.indexOf(cs + 'devoice') is 0

        # Listen for joins 
        client.addListener 'join', (channel, nick, message) ->
                # Get the host of the user that joined
                host = message.user + '@' + message.host
                
                # Check if the user exists
                if !config[i].users[nick]?
                        config[i].users[nick] = {}
                        updateConfig config

                # Check if the channel exists for the user
                if !config[i].users[nick][channel]?
                        config[i].users[nick][channel] = {}
                        config[i].users[nick][channel].mode = ""
                        config[i].users[nick][channel].host = host
                        updateConfig config

                # Check if the user is op or not
                isop = (config[i].users[nick][channel].mode is '+o')
                isop = isop and (config[i].users[from][channel].host is host)

                if isop
                        client.send ':'+nick+'!'+host, 'MODE', channel, '+o', nick
                        
                else if config[i].users[from][channel].mode is '+v'
                        if config[i].users[from][channel].host is host
                                client.send ':'+nick+'!'+host, 'MODE', channel, '+v', nick

        # Return commands
        return commands

# op command
op = (client, config, nick, message) ->
        if !isop
                client.say message.args[0], nick + ': you don\'t have permission to do this!'
                return

        # Now we let the real op do stuff
        if message.args[1].replace(/\ /g, '') is (cs + 'op')
                client.say message.args[0], nick + ': you can\'t op the ghosts in here!'

# deop command
deop = (client, config, nick, msg) ->
        if !isop
                client.say message.args[0], nick + ': you don\'t have permission to do this!'
                return

        # Now we let the real op do stuff
        if message.args[1].replace(/\ /g, '') is (cs + 'deop')
                client.say message.args[0], nick + ': you can\'t deop the ghosts in here!'

# voice command
voice = (client, config, nick, msg) ->
        if !isop
                client.say message.args[0], nick + ': you don\'t have permission to do this!'
                return

        # Now we let the real op do stuff
        if message.args[1].replace(/\ /g, '') is (cs + 'voice')
                client.say message.args[0], nick + ': you can\'t voice the ghosts in here!'

# devoice command
devoice = (client, config, nick, msg) ->
        if !isop
                client.say message.args[0], nick + ': you don\'t have permission to do this!'
                return

        # Now we let the real op do stuff
        if message.args[1].replace(/\ /g, '') is (cs + 'devoice')
                client.say message.args[0], nick + ': you can\'t devoice the ghosts in here!'

# Update config
updateConfig = (config) ->
        fs.writeFileSync './config.json', JSON.stringify config
        console.log green + 'Config file updated' + reset