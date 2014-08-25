<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0" xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
    <NamedLayer>
        <Name>Zones en Agglomeraties</Name>
        <UserStyle>
            <Title>Zones en Agglomeraties</Title>
            <Abstract>Simpele stijl voor Zones en Agglomeraties</Abstract>
            <FeatureTypeStyle>



                <Rule>
                    <Name>Zones</Name>
                    <Title>Zones</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>zone_type</ogc:PropertyName>
                            <ogc:Literal>noagg</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <PolygonSymbolizer>
                      <Fill>
                        <CssParameter name="fill">#5e9874</CssParameter>
                      </Fill>
                      <Stroke>
                        <CssParameter name="stroke">#000000</CssParameter>
                        <CssParameter name="stroke-width">0.26</CssParameter>
                      </Stroke>
                    </PolygonSymbolizer>

                    <TextSymbolizer>
                        <Label>
                            <ogc:PropertyName>zone_name</ogc:PropertyName>

                        </Label>

                        <Font>
                            <CssParameter name="font-family">
                                <ogc:Literal>Lucida Sans Regular</ogc:Literal>
                            </CssParameter>

                            <CssParameter name="font-size">
                                <ogc:Literal>10</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="font-weight">
                                <ogc:Literal>bold</ogc:Literal>
                            </CssParameter>
                        </Font>


                        <Fill>
                            <CssParameter name="fill">#000000</CssParameter>
                        </Fill>

                    </TextSymbolizer>

                </Rule>
                <Rule>
                    <Name>Agglomeraties</Name>
                    <Title>Agglomeraties</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>zone_type</ogc:PropertyName>
                            <ogc:Literal>agg</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <PolygonSymbolizer>
                      <Fill>
                        <CssParameter name="fill">#c96106</CssParameter>
                      </Fill>
                      <Stroke>
                        <CssParameter name="stroke">#000000</CssParameter>
                        <CssParameter name="stroke-width">0.26</CssParameter>
                      </Stroke>
                    </PolygonSymbolizer>

                    <TextSymbolizer>
                        <Label>
                            <ogc:PropertyName>zone_name</ogc:PropertyName>

                        </Label>

                        <Font>
                            <CssParameter name="font-family">
                                <ogc:Literal>Lucida Sans Regular</ogc:Literal>
                            </CssParameter>

                            <CssParameter name="font-size">
                                <ogc:Literal>10</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="font-weight">
                                <ogc:Literal>bold</ogc:Literal>
                            </CssParameter>
                        </Font>


                        <Fill>
                            <CssParameter name="fill">#000000</CssParameter>
                        </Fill>

                    </TextSymbolizer>

                </Rule>

            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>


                                     