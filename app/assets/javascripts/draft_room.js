(function() {
  // the rest of this function will only load on '/leagues/:id/draft_room'
  $('body').on('leagues:draft_room', function() {

      // check out dm.userData for all your current_user ID's being passed down from Rails
      var DraftRoom = require('components/draft-room');

      var el = $('.draft-room-container');

      var props = {
        leagueID: dm.userData.league_id,
        currentUserID: dm.userData.current_user_id,
        currentOwnerID: dm.userData.current_owner_id,
        currentDraftPick: dm.userData.current_draft_pick,
        currentOwnerTurn: dm.userData.current_owner_turn
      }

      ReactDOM.render(React.createElement(DraftRoom, props), $(el)[0]);
  });
})()
