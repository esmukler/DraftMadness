(function() {
  // the rest of this function will only load on '/leagues/:id/draft_room'
  $('.leagues.draft_room').ready(function(el) {

      // check out dm.userData for all your current_user ID's being passed down from Rails
      console.log('hello world!');
      var DraftRoom = require('components/draft-room');

      var el = $('.draft-room-container');

      var props = {
        leagueID: dm.userData.league_id,
        currentUserID: dm.userData.current_user_id,
        currentOwnerID: dm.userData.current_owner_id
      }

      ReactDOM.render(React.createElement(DraftRoom, props), $(el)[0]);
  });
})()
