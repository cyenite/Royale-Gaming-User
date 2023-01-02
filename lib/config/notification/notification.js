addEventListener("fetch", event => {
    event.respondWith(handleRequest(event.request))
  })
  
  async function handleRequest(request) {
  //   return new Response("Hello world")
  const {
          method,
          url
      } = request
      const {
          host,
          pathname
      } = new URL(url)
  
      const body = await request.clone().json();
  const firebaseSecretKey = 'your firebase secret key';
  const firebaseRequest = await fetch('https://fcm.googleapis.com/fcm/send', {
                  method: "POST",
                  body:  JSON.stringify({
                      "priority": "high",
                      "data": {
                          "click_action": "FLUTTER_NOTIFICATION_CLICK",
                          "id": "0",
                          "status": "done"
                      },
                      "notification": {
                          "body": body['message'],
                          "title": body['title'],
                          "image": body['image'],
                          "sound": "default",
                      },
  
                      "to": body['topic']
                  }),
                  headers: {
                      'content-type': 'application/json',
                      'Authorization': 'key=' + firebaseSecretKey,
                  },
  
              }
  
          );
          return firebaseRequest;
  
  }