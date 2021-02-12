
require("packs/application")

import $ from 'jquery'

import 'ol/ol.css';
import Feature from 'ol/Feature';
import Overlay from 'ol/Overlay';

import Map from 'ol/Map';
import View from 'ol/View';
import GeoJSON from 'ol/format/GeoJSON';
import Circle from 'ol/geom/Circle';
import { Tile as TileLayer, Vector as VectorLayer } from 'ol/layer';
import { OSM, Vector as VectorSource } from 'ol/source';
import { Circle as CircleStyle, Fill, Stroke, Style, Icon } from 'ol/style';
import { OverviewMap, defaults as defaultControls } from 'ol/control';
import { transform } from 'ol/proj';
import { toStringHDMS } from 'ol/coordinate';
import Geolocation from 'ol/Geolocation';
import Point from 'ol/geom/Point';


$(document).on('turbolinks:load', () => {
  var container = document.getElementById('popup');
  var content = document.getElementById('popup-content');
  var closer = document.getElementById('popup-closer');
  
  var view = new View({
    center: [0,0],
    zoom: 12,
    maxZoom: 20
  });

  var overlay = new Overlay({
    element: container,
    autoPan: true,
    autoPanAnimation: {
      duration: 250
    }
  });

  var map = new Map({
    layers: [
      new TileLayer({
        source: new OSM()
      })
    ],
    target: 'js-map',
    controls: defaultControls({
      attributionOptions: {
        collapsible: false
      }
    }),
    overlays: [overlay],
      view: view
    });

  var geolocation = new Geolocation({
    // enableHighAccuracy must be set to true to have the heading value.
    trackingOptions: {
      enableHighAccuracy: true,
    },
    projection: view.getProjection(),
    tracking: true
  });

  geolocation.on('change:position', (coordinates) => {
    var coordinates = geolocation.getPosition();
    view.setCenter(coordinates);
    addLocationPoint(coordinates, "myCurrentPosition", [255,0,0]);
  });

  let addLocationPoint = (coords, layerName, pointerColor) => {
    var currentPositionFeatures = new Feature({
      geometry: new Point(coords)
    });

    currentPositionFeatures.setStyle(
      new Style({
        image: new Icon({
          color: pointerColor,
          anchor: [0.5, 0.5],
          anchorXUnits: 'fraction',
          anchorYUnits: 'fraction',
          src: 'https://www.google.co.in/maps/vt/icon/name=assets/icons/spotlight/spotlight_pin_v3_shadow-1-small.png,assets/icons/spotlight/spotlight_pin_v3-1-small.png,assets/icons/spotlight/spotlight_pin_v3_dot-1-small.png&highlight=ff000000,ea4335,a50e0e?scale=1',
          crossOrigin: 'anonymous'
        })
      })
    );
    
    var layer = new VectorLayer({
      source: new VectorSource({
        features: [currentPositionFeatures]
      })
    });
    layer.set('name', layerName);
    map.addLayer(layer);
  }

  map.on('singleclick', (e) => {
    removeLocationPoint('MarkerPointLayer');
    var coords = map.getCoordinateFromPixel(e.pixel);
    var zoomLevel=view.getZoom();
    addLocationPoint(coords, 'MarkerPointLayer', [121,82,0]);
    var hdms = toStringHDMS(coords);
    var coordinate=transform(coords, "EPSG:3857", "EPSG:4326");
    var customHTML = '<p>You clicked here:</p><code>' + hdms + '</code>';
    customHTML += '<button type="button" id="shareLocation" class="btn btn-primary" style="margin-left: 50px;" >Share</button>'
    content.innerHTML=customHTML;
    overlay.setPosition(coords);	
    var btn = document.getElementById("shareLocation");
    btn.addEventListener('click', (e) => {
      openLocationShareModal(coordinate[0],coordinate[1]);
    })
  })

  let removeLocationPoint = (layerName) => {
    try {
      map.getLayers().forEach((layer) => {
        console.log(layer.get('name'));
        if (layer.get('name') != undefined && layer.get('name') === layerName) {
          map.removeLayer(layer);
        }
      });
    }catch(err) {};
  }

  let openLocationShareModal = (lng, lat) => {
    var html = "";
    html += "<input type='hidden' id='lng' name='lng' value='" + lng + "'/>"
    html += "<input type='hidden' id='lat' name='lat' value='" + lat + "'/>"
    html += "<div class='w-100 float-left'>";
    html += "<p class='w-40 float-left' > Share Location as Public: </p>";
    html += "<input type='checkbox' class='form-check-input' id='sharePublicChk' checked style='margin:7 0 0 10;'/>";
    html += "</div>";
    html += "<div class='w-100 float-left d-none' id='selectPeopleDiv' >";
    html += "<p class='w-40 float-left' > Select User(s): </p>";
    html += "<select class='custom-select' id='filtering' style='width:300px;' >";
    $.each(sharableUserList, ( index, value ) => {
      html +="<option value="+value.id+">"+value.email+"</option>";
    });
    html += "</select>";
    html += "</div>";
    
    $("#shareLocationModal .modal-body").html(html);
    var chk = document.getElementById("sharePublicChk");
    chk.addEventListener('change', function(){
      showHideSelectPeopleDiv(this);
    })
    $("#filtering").select2( {
      placeholder: "Select People...",
      allowClear: true,
      multiple: true
    } );
    $("#shareLocationModal").modal();
    var submitBtn = document.getElementById("modal_submit");
    submitBtn.addEventListener('click', () => {
      share_location();
    })
  }

  let showHideSelectPeopleDiv = (obj) => {
    if(obj.checked){
      $("#selectPeopleDiv").addClass("d-none");
    }else{
      $("#selectPeopleDiv").removeClass("d-none");
    }
  }

  let share_location = () => {
    $('#modal_submit').attr("disabled", "disabled");
    $('#modal_submit').html("<span class='spinner-border spinner-border-sm'></span>  Share")
    var lng = $("#lng").val();
    var lat = $("#lat").val();
    var isPublic = $("#sharePublicChk").prop("checked");
    var user_id_arr = ['public'];
    if(!isPublic){
      user_id_arr = $("#filtering").val();
    }
    if(user_id_arr.length == 0){
      alert("Please select atleast one people.");
      $('#modal_submit').removeAttr("disabled");
      $('#modal_submit').html("Share");	
      return;
    }
    var data_srt = "latitude=" + lat + "&longitude=" + lng + "&user_id_arr=" + user_id_arr;
    $.ajax({
      type: "POST",
      url: '/save_new_shared_location',
      data: data_srt,
      headers: {
        'X-CSRF-Token': formAuthenticityToken
      },
      success: function(msg){
        $('#shareLocationModal').modal('hide');
        alert(msg);
        $('#modal_submit').removeAttr("disabled");
        $('#modal_submit').html("Share");
      },complete: function (xhr, status) {
        if(xhr.status == 401){
          alert(xhr.responseText)
        }
        parent.window.location.reload();
      }
    });
  }
  
  closer.onclick = function() {
    overlay.setPosition(undefined);
    closer.blur();
    return false;
  };
});