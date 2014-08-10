https = require("https")
#username = process.argv.slice(2).toString()
#console.log "arg " + username
getRepos = (username, callback) ->
  options =
    host: "api.github.com"
    path: "/users/" + username + "/repos"
    method: "GET"
    headers:
      "user-agent": "node.js"

  request = https.request(options, (response) ->
    user = ""
    response.on "data", (chunk) ->
      user += chunk.toString()
      return

    response.on "end", ->
      repos = []
      json = JSON.parse(user)
      if json.message is "Not Found"
        callback false
      else
        for repo of json
          
          repos.push
            name: json[repo].name
            description: json[repo].description

        callback repos
      return

    response.on "error", ->
      callback false
      return

    return
  )
  request.on "error", (error) ->
    console.log "ERROR: " + error.message
    callback false
    return

  request.end()
  return

argumentLength = process.argv.length
if argumentLength < 3 
  console.log "Command Not Found"
else
  username = process.argv.slice(2).toString()
  getRepos username, (repos) ->
    if repos
      repos.forEach (repo) ->
        console.log "Name: " + repo.name
        return

    else
      console.log "Username Doesn't exist"
    return

