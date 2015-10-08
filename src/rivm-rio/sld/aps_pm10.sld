<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0" xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
    <NamedLayer>
        <Name>rivm_aps_pm10</Name>
        <UserStyle>
            <Name>rivm_aps_pm10</Name>
            <Title>rivm_aps_pm10</Title>
            <Abstract>Style for RIVM APS raster PM10</Abstract>
            <FeatureTypeStyle>
                <FeatureTypeName>Feature</FeatureTypeName>
                <Rule>
                    <RasterSymbolizer>
                        <ColorMap type="intervals">
                            <ColorMapEntry color="#FFFFFF" quantity="0" label="No Data" opacity="0.0"/>
                            <ColorMapEntry color="#6699CC" quantity="10" label="&lt; 10 ug/m3" opacity="1.0"/>
                            <ColorMapEntry color="#99CCCC" quantity="30" label="10-30 ug/m3" opacity="1.0"/>
                            <ColorMapEntry color="#CCFFFF" quantity="50" label="30-50 ug/m3" opacity="1.0"/>
                            <ColorMapEntry color="#FFFFCC" quantity="75" label="50-75 ug/m3" opacity="1.0"/>   <!-- Yellow -->
                            <ColorMapEntry color="#FFCC66" quantity="125" label="75-125 ug/m3" opacity="1.0"/>
                            <ColorMapEntry color="#FF9966" quantity="200" label="125-200 ug/m3" opacity="1.0"/>
                            <ColorMapEntry color="#990033" quantity="20000" label="&gt; 200 ug/m3" opacity="1.0"/>
                         </ColorMap>
                    </RasterSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>