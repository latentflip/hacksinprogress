myapp = angular.module 'myapp', ['firebase']

myapp.directive 'draggable', ->
  restrict: 'A'
  scope: {
    shape: '='
  }
  link: (scope, element, attrs) ->
    moving = false
    $(element).mousedown (event) -> moving = true
    $(document).mouseup (event) -> moving = false

    lastPos = null
    $(document).bind 'mousemove', (event) ->
      if moving
        pos = { x: event.clientX, y: event.clientY } 
        if lastPos
          if event.metaKey
            console.log 'size'
            scope.shape.size += pos.x - lastPos.x
          else
            scope.shape.x += pos.x - lastPos.x
            scope.shape.y += pos.y - lastPos.y
          scope.$apply()

        lastPos = pos

myapp.controller 'MyCtrl', ['$scope', 'angularFire', ($scope, angularFire) ->
  url = 'https://latentflip.firebaseio.com/shapes'
  $scope.shapes = angularFire(url, $scope, 'shapes', [])

  $scope.shapes.then ->
    s.size or=10 for s in $scope.shapes
    $scope.addShape = ->
      $scope.shapes.push { x: 5, y: 5, size: 10 }
    
]
