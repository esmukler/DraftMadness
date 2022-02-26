(function() {
  // the rest of this function will only load on '/leagues/:id/draft_room'
  $('body').on('leagues:draft_room', function() {
      // var DraftRoom = require('components/draft-room');

      var el = $('.draft-room-container');
      if (el.length) {
          var leagueID = $(el).data('leagueId');
          var url = '/api/leagues/' + leagueID + '/draft_room';

          $.ajax(url, {
              type: 'GET',
              dataType: 'json',
              success: function(data) {
                  // ReactDOM.render(React.createElement(DraftRoom, data), $(el)[0]);
              }
          });
      }

      // var props = {
      //   leagueID: dm.userData.league_id,
      //   currentUserID: dm.userData.current_user_id,
      //   currentOwnerID: dm.userData.current_owner_id,
      //   currentDraftPick: dm.userData.current_draft_pick,
      //   currentOwnerTurn: dm.userData.current_owner_turn
      // }
      //
  });
})()
