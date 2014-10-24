<StyledLayerDescriptor version="1.0.0" xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
  xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <NamedLayer>
      <!-- From: http://onegeology.naturalsciences.be/py/thermomap_temperature.sld-->
    <Name>temperature1</Name>
    <UserStyle>

      <FeatureTypeStyle>
        <FeatureTypeName>Feature</FeatureTypeName>

        <!-- -10 to -8 degree Celsius -->
        <Rule>
        <Title>-10 to -8 degree Celsius</Title>
          <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>-10</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>-8</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
           </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#122491</ogc:Literal>
              </CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>

        <Rule>
          <Title>-8 to -6 degree Celsius</Title>
          <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>-8</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>-6</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
          </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#33438e</ogc:Literal>
              </CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>

        <Rule>
          <Title>-6 to -4 degree Celsius</Title>
                    <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>-6</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>-4</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
                      </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#55628b</ogc:Literal>
              </CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>

        <Rule>
          <Title>-4 to -2 degree Celsius</Title>
          <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>-4</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>-2</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
          </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#778189</ogc:Literal>
              </CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>

        <Rule>
         <Title>-2 to 0 degree Celsius</Title>
          <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>-2</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>0</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
          </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#99a186</ogc:Literal>
              </CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>

        <Rule>
           <Title>0 to 2 degree Celsius</Title>
          <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>0</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>2</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
          </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#bbc084</ogc:Literal>
              </CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>

        <Rule>
          <Title>2 to 4 degree Celsius</Title>
          <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>2</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>4</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
          </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#dddf81</ogc:Literal>
              </CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>

        <Rule>
          <Title>4 to 6 degree Celsius</Title>
          <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>4</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>6</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
          </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#feff7f</ogc:Literal>
              </CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>

    <!-- northwest -->
        <Rule>
          <Title>6 to 8 degree Celsius</Title>
          <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>6</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>8</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
          </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#feda6c</ogc:Literal>
              </CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>

        <Rule>
          <Title>8 to 10 degree Celsius</Title>
          <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>8</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>10</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
          </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#feb65a</ogc:Literal>
              </CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>

        <Rule>
          <Title>10 to 12 degree Celsius</Title>
          <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>10</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>12</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
          </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#fe9148</ogc:Literal>
              </CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>

        <Rule>
          <Title>12 to 14 degree Celsius</Title>
          <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>12</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>14</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
          </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#fe6d36</ogc:Literal>
              </CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>

        <Rule>
          <Title>14 to 16 degree Celsius</Title>
          <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>14</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>16</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
          </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#fe4824</ogc:Literal>
              </CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>

        <Rule>
          <Title>16 to 18 degree Celsius</Title>
          <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>16</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>18</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
          </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#fe2412</ogc:Literal>
              </CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>


        <Rule>
          <Title>18 to 20 degree Celsius</Title>
          <ogc:Filter>
          <ogc:And>
                <ogc:PropertyIsGreaterThan>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>18</ogc:Literal>
                  </ogc:PropertyIsGreaterThan>
                  <ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:PropertyName>temp_class</ogc:PropertyName>
                    <ogc:Literal>20</ogc:Literal>
                  </ogc:PropertyIsLessThanOrEqualTo>
            </ogc:And>
          </ogc:Filter>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">
                <ogc:Literal>#ff0000</ogc:Literal>
              </CssParameter>
            </Fill>

          </PolygonSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
