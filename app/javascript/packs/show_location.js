require("packs/application")

import 'ol/ol.css';
import Map from 'ol/Map';
import View from 'ol/View';
import { fromLonLat } from 'ol/proj';
import { Tile as TileLayer, Vector as VectorLayer } from 'ol/layer';
import { OSM, Vector as VectorSource } from 'ol/source';
import {OverviewMap, defaults as defaultControls} from 'ol/control';
import { Circle as CircleStyle, Fill, Stroke, Style, Icon } from 'ol/style';
import Feature from 'ol/Feature';
import Point from 'ol/geom/Point';

$(document).on('turbolinks:load', () => {
	var view = new View({
		center: fromLonLat([longitude,latitude]),
		zoom: 12,
		maxZoom: 20
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
		view: view
	});
	
	let addLocationPoint = (coords,layerName,pointerColor) => {
		var iconFeature = new Feature({
			geometry: new Point(coords)
		});
		
		var iconStyle = new Style({
			image: new Icon({
				color: pointerColor,
				anchor: [0.5, 0.5],
				anchorXUnits: 'fraction',
				anchorYUnits: 'fraction',
				src: 'https://www.google.co.in/maps/vt/icon/name=assets/icons/spotlight/spotlight_pin_v3_shadow-1-small.png,assets/icons/spotlight/spotlight_pin_v3-1-small.png,assets/icons/spotlight/spotlight_pin_v3_dot-1-small.png&highlight=ff000000,ea4335,a50e0e?scale=1',
				crossOrigin: 'anonymous',
			})
		});
		iconFeature.setStyle(iconStyle);
		var layer = new VectorLayer({
			source: new VectorSource({
				features: [iconFeature]
			})
		});
		layer.set('name', layerName)
		map.addLayer(layer);
	}
	console.log(fromLonLat([longitude,latitude]))
	addLocationPoint(fromLonLat([longitude,latitude]),"coordinatePosition",[255,0,0]);
});