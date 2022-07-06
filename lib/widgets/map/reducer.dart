import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/widgets/map/action.dart';
import 'package:app/widgets/map/state.dart';
import 'package:redux/redux.dart';

final Reducer<MapState> mapReducer = combineReducers(
  [
    TypedReducer(_addMarker),
    TypedReducer(_updateMarker),
    TypedReducer(_removeMarker),
    TypedReducer(_checkPointsInPolygon),
    TypedReducer(_startDrawPolygon),
    TypedReducer(_addPolygonPoint),
    TypedReducer(_endDrawPolygon),
    TypedReducer(_setController),
    TypedReducer(_updateCameraPosition),
  ],
);

MapState _addMarker(MapState state, AddMarker action) {
  if (state.id == action.mapId) {
    final markers = state.markers;
    markers.add(action.marker);
    return state.copyWith(
      markers: markers,
    );
  } else {
    return state;
  }
}

MapState _updateMarker(MapState state, UpdateMarker action) {
  if (state.id == action.mapId) {
    final markers = keyByMarkerId(state.markers);
    markers[action.id] = markers[action.id]!.copyWith(
      alphaParam: action.alphaParam,
      anchorParam: action.anchorParam,
      clickableParam: action.clickableParam,
      draggableParam: action.draggableParam,
      iconParam: action.iconParam,
      infoWindowEnableParam: action.infoWindowEnableParam,
      infoWindowParam: action.infoWindowParam,
      onDragEndParam: action.onDragEndParam,
      onTapParam: action.onTapParam,
      positionParam: action.positionParam,
      rotationParam: action.rotationParam,
      visibleParam: action.visibleParam,
    );

    return state.copyWith(
      markers: markers.values.toList(),
    );
  } else {
    return state;
  }
}

MapState _removeMarker(MapState state, RemoveMarker action) {
  if (state.id == action.mapId) {
    final markers = keyByMarkerId(state.markers);
    markers.remove(action.createId);

    return state.copyWith(
      markers: markers.values.toList(),
    );
  } else {
    return state;
  }
}

MapState _checkPointsInPolygon(MapState state, CheckPointsInPolygon action) {
  if (state.id == action.mapId) {
    final markers = state.markers;
    final markersInPolygon = <Marker>[];
    final polygon = state.polygon;
    for (var marker in markers) {
      if (AMapTools.latLngIsInPolygon(marker.position, polygon)) {
        markersInPolygon.add(marker);
      }
    }

    return state.copyWith(
      markersInPolygon: markersInPolygon,
    );
  } else {
    return state;
  }
}
MapState _startDrawPolygon(MapState state, StartDrawPolygon action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      drawing: true,
    );
  } else {
    return state;
  }
}

MapState _addPolygonPoint(MapState state, AddPolygonPoint action) {
  if (state.id == action.mapId) {
    final position = action.position;
    final polygon = state.polygon;

    polygon.add(position);

    return state.copyWith(
      polygon: polygon,
    );
  } else {
    return state;
  }
}

MapState _endDrawPolygon(MapState state, EndDrawPolygon action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      drawing: false,
    );
  } else {
    return state;
  }
}

MapState _setController(MapState state, SetController action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      controller: action.controller,
    );
  } else {
    return state;
  }
}

MapState _updateCameraPosition(MapState state, UpdateCameraPosition action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      cameraPosition: action.cameraPosition,
    );
  } else {
    return state;
  }
}