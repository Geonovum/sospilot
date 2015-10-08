<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0" xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
    <NamedLayer>
        <Name>rivm_aps_no2</Name>
        <UserStyle>
            <Name>rivm_aps_no2</Name>
            <Title>rivm_aps_no2</Title>
            <Abstract>Style for RIVM APS raster NO2</Abstract>
            <FeatureTypeStyle>
                <FeatureTypeName>Feature</FeatureTypeName>
                <Rule>
                    <RasterSymbolizer>
                        <ColorMap type="intervals">
                            <ColorMapEntry color="#FFFFFF" quantity="0.0001" opacity="0.0"/>
                            <ColorMapEntry color="#6699CC" quantity="20.00" opacity="1.0"/>
                            <ColorMapEntry color="#99CCCC" quantity="50.00" opacity="1.0"/>
                            <ColorMapEntry color="#CCFFFF" quantity="200.00" opacity="1.0"/>
                            <ColorMapEntry color="#FFFFCC" quantity="250.00" opacity="1.0"/>   <!-- Yellow -->
                            <ColorMapEntry color="#FFCC66" quantity="350.00" opacity="1.0"/>
                            <ColorMapEntry color="#FF9966" quantity="400.00" opacity="1.0"/>
                            <ColorMapEntry color="#990033" quantity="2000.00" opacity="1.0"/>
                        </ColorMap>
                    </RasterSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
