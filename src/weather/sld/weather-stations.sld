<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0"
                       xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld"
                       xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink"
                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <!-- a Named Layer is the basic building block of an SLD document -->
    <NamedLayer>
        <Name>Weather Stations</Name>
        <UserStyle>
            <!-- Styles can have names, titles and abstracts -->
            <Title>Weather Stations</Title>
            <Abstract>Weather Stations style</Abstract>
            <!-- FeatureTypeStyles describe how to render different features -->
            <!-- A FeatureTypeStyle for rendering points -->
            <FeatureTypeStyle>
                <Rule>
                    <Name>Weather Stations</Name>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>star</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#eee512</CssParameter>
                                    <CssParameter name="fill-opacity">0.6</CssParameter>
                                </Fill>
                                <Stroke>
                                    <CssParameter name="stroke">#aba85f</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>14</Size>
                        </Graphic>
                    </PointSymbolizer>

                    <TextSymbolizer>
                        <Label>
                            <ogc:PropertyName>name</ogc:PropertyName>
                        </Label>
                        <Halo>
                            <Radius>3</Radius>
                            <Fill>
                                <CssParameter name="fill">#FFFFFF</CssParameter>
                            </Fill>
                        </Halo>

                        <Font>
                            <CssParameter name="font-family">
                                <ogc:Literal>Lucida Sans Regular</ogc:Literal>
                            </CssParameter>

                            <CssParameter name="font-size">
                                <ogc:Literal>12</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="font-style">
                                <ogc:Literal>normal</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="font-weight">
                                <ogc:Literal>bold</ogc:Literal>
                            </CssParameter>
                        </Font>

                        <LabelPlacement>
                            <PointPlacement>
                                <AnchorPoint>
                                    <AnchorPointX>0.5</AnchorPointX>
                                    <AnchorPointY>0.0</AnchorPointY>
                                </AnchorPoint>
                                <Displacement>
                                    <DisplacementX>0</DisplacementX>
                                    <DisplacementY>5</DisplacementY>
                                </Displacement>
                            </PointPlacement>
                        </LabelPlacement>
                        <Fill>
                            <CssParameter name="fill">#6c8900</CssParameter>
                        </Fill>

                    </TextSymbolizer>
                </Rule>

            </FeatureTypeStyle>

        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
