angular.module('ngApp').controller 'AddImageController', ($scope,$http,rootUrl) ->
    $scope.focusImageUrl = true
    $scope.addResult = ''
    $scope.closeModal = ->
        $scope.$close()
    $scope.add = (image) =>
        if !image || (image.imageUrl.indexOf('http://') != 0 && image.imageUrl.indexOf('https://') != 0)
            return $scope.addResult = 'Please enter an address starting with http:// or https://'
        $http.post "#{rootUrl}/api/pics", 
                src:image.imageUrl
                title:image.title
            .success (result) ->
                scopeImg = angular.element($('#addImageForm')).scope().image
                scopeImg.imageUrl = ''
                scopeImg.title = ''
                $scope.addResult = 'Image added successfully.'
            .error (data,status,headers,config) ->
                $scope.addResult = "#{status} Failed to add the image."
