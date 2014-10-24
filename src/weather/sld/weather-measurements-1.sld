<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0"
                       xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld"
                       xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- a Named Layer is the basic building block of an SLD document -->
    <NamedLayer>
        <Name>weather_measurements</Name>
        <UserStyle>
            <!-- Styles can have names, titles and abstracts -->
            <Title>Geonovum Weather Measurements</Title>
            <Abstract>Geonovum Weather Measurements style</Abstract>
            <IsDefault>1</IsDefault>
            <!-- FeatureTypeStyles describe how to render different features -->
            <!-- A FeatureTypeStyle for rendering points -->
            <FeatureTypeStyle>
                <Rule>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>square</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#cc0066</CssParameter>
                                    <CssParameter name="fill-opacity">1.0</CssParameter>
                                </Fill>
                                <Stroke>
                                    <CssParameter name="stroke">#660033</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
                                    <CssParameter name="stroke-linecap">round</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>40</Size>
                        </Graphic>
                    </PointSymbolizer>

                    <TextSymbolizer>
                        <Label>
                            <ogc:Function name="strConcat">
                                <ogc:Function name="numberFormat">
                                    <ogc:Literal>##</ogc:Literal>
                                    <ogc:PropertyName>outtemp_c</ogc:PropertyName>
                                </ogc:Function>
                                <ogc:Literal>&#176;C</ogc:Literal>
                            </ogc:Function>
                        </Label>

                        <Font>
                            <CssParameter name="font-family">
                                <ogc:Literal>Lucida Sans Regular</ogc:Literal>
                            </CssParameter>

                            <CssParameter name="font-size">
                                <ogc:Literal>13</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="font-weight">
                                <ogc:Literal>bold</ogc:Literal>
                            </CssParameter>
                        </Font>
                        <LabelPlacement>
                            <PointPlacement>
                                <AnchorPoint>
                                    <AnchorPointX>0.5</AnchorPointX>
                                    <AnchorPointY>0.5</AnchorPointY>
                                </AnchorPoint>
                            </PointPlacement>
                        </LabelPlacement>

                        <Fill>
                            <CssParameter name="fill">#FFFF99</CssParameter>
                        </Fill>

                    </TextSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
