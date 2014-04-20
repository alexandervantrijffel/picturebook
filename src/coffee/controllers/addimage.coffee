angular.module('ngApp').controller 'AddImageController', ($scope,$http) ->
    $scope.focusImageUrl = true
    $scope.addResult = ''
    $scope.add = (image) =>
        if !image || (image.imageUrl.indexOf('http://') != 0 && image.imageUrl.indexOf('https://') != 0)
            $scope.addResult = 'Please enter an address starting with http:// or https://'
        else if image.imageUrl
            $http.post '/api/images/add', url:image.imageUrl
                .success (result) ->
                    angular.element($('#addImageForm')).scope().image.imageUrl = ''
                    $scope.addResult = 'Image added successfully.'
                .error (data,status,headers,config) ->
                    $scope.addResult = "#{status} Failed to add the image."
