@FollowsCtrl = ['$scope', '$http', '$location', ($scope, $http, $location) ->
  $scope.init = (data) ->
    [$scope.count, $scope.labels, $scope.followed] = data
    $scope.disabled = !$scope.user?
    $scope.title = "新活动发布时会给您发送邮件通知"
    if $scope.disabled
      $scope.title = "您需要登录后才能关注活动"
      $scope.href = "/users/sign_in?return_to=#{$location.absUrl()}"
  $scope.follow = ->
    return if $scope.disabled
    $scope.followed = !$scope.followed
    action = if $scope.followed then 'follow' else 'unfollow'
    $http.post("/events/#{$scope.event.id}/#{action}").success (data) -> $scope.count = data.count
]

@JoinCtrl = ['$scope', '$http', '$location', 'participants', ($scope, $http, $location, participants) ->
  $scope.init = (data) ->
    [$scope.count, $scope.labels, $scope.titles, $scope.joined] = data
    $scope.disabled = !$scope.user? || $scope.event.expired
    if $scope.disabled
      $scope.title = "您需要登录后才能关注活动"
      $scope.href = "/users/sign_in?return_to=#{$location.absUrl()}"
    if $scope.event.expired
      $scope.joined = 'expired'
      $scope.title = "已过期，请继续关注下一期活动"
      $scope.href= null
  $scope.join = ->
    return if $scope.disabled
    action = if $scope.joined then 'quit' else 'join'
    $http.post("/events/#{$scope.event.id}/#{action}").success (data) ->
      $scope.count = data.count
      $scope.notice = data.notice
      $scope.joined = data.joined
      participants.reload()
]

@ParticipantsCtrl = ['$scope', 'participants', ($scope, participants) ->
  $scope.participants= participants.data
]
