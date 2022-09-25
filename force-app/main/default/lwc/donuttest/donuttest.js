import { LightningElement, track, api } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import C3 from '@salesforce/resourceUrl/c3'; //load the c3 and d3 from the static resources.
import D3 from '@salesforce/resourceUrl/d3';
export default class DonutChartWithHover extends LightningElement {
  @api chartDataValue;
  @track chart;
  @track arcWidth1;
  @track mapOfValues = [{},{},{},{}];
  @track loadingInitialized = false;
  librariesLoaded = false;
  @track arrColor = ["#75C5B8","#EFE459","#EA7A48"] ; 
  @track arrKeys = [];
  @track legend = {
    Top: false,
    Bottom: false,
    Right: true,
    Left: false
  };
  @track arcWidth=50;
  @track outerWidth=250;

  //Comment from AB 1
  renderedCallback() {
    if (this.librariesLoaded)
      this.drawChart();
    //this.librariesLoaded = true;
    if (!this.loadingInitialized) {
      this.loadingInitialized = true;
      /*
        We have added the a parameter t and assigned the current time to it. 
        This is done to make sure the cache is refrehed everytime the scripts are loaded.
        If we do not do this then there is an issues if we add multiple charts in a single component.
      */
      Promise.all([
        loadScript(this, D3 + '/d3.min.js'),
          loadScript(this, C3 + '/c3.min.js?t=' + new Date().getTime()),
          loadStyle(this, C3 + '/c3.min.css?t=' + new Date().getTime())
        ])
        .then(() => {
          this.librariesLoaded = true;
          //Call the charting method when all the dependent javascript libraries are loaded. 
          this.drawChart();
        })
        .catch(error => {
          //console.log('The error ', error);
        });
    }
  }

  connectedCallback() {
    this.mapOfValues = [];
    this.arrColor = [];
    this.arrKeys = [];
    this.chartData = this.chartDataValue;
    document.hoverValues = this.chartDataValue;
    for (let i = 0; i < this.chartData.length; i++) {
      let tempData = [this.chartData[i]['dataLabel'], this.chartData[i]['data']];
      console.log('tempData ' + tempData);
      this.mapOfValues.push(tempData);
      console.log('this.mapOfValues ' + this.mapOfValues);
      this.arrColor.push(this.chartData[i]['color']);
      this.arrKeys.push(this.chartData[i]['dataLabel']);
      console.log('this.arrKeys' + this.arrKeys);
      console.log('this.arrColor' + this.arrColor);
    }
  }

  drawChart() {
    this.chart = c3.generate({
      bindto: this.template.querySelector('div.c1'), //Select the div to which the chart will be bound to.
      size: {
        height: this.outerWidth,
      },
      legend: {
        show: false, // We are using custom legends
        position: 'bottom',
        squareSymbol: false,
      },
      data: {
        columns: this.mapOfValues,
        type: 'donut',
      },
      color: {
        pattern: this.arrColor,
      },

      donut: {
        cutoutPercentage: 50,
        borderAlign: 'inner',
        rotation: -0.5,
        decimals: 0,
        width: this.arcWidth, // Width of the arcs
        label: {
          show: false,
        },
      },
      tooltip: {
        horizontal: false,
        format: {
          value: function (value, ratio, id) {
            var format = d3.format('.2f'); // 2 decimal pont formatting
            return format(ratio * 100) + '%';
          }
        },

        contents: function (d, defaultTitleFormat, defaultValueFormat, color) {
          var $$ = this,
            config = $$.config,
            //titleFormat = config.tooltip_format_title || defaultTitleFormat,
            nameFormat = config.tooltip_format_name || function (name) {
              return name;
            },
            valueFormat = config.tooltip_format_value || defaultValueFormat,
            //text, title, 
            value, i, name, bgcolor;
          for (i = 0; i < d.length; i++) {
            if (!(d[i] && (d[i].value || d[i].value === 0))) {
              continue;
            }
            name = nameFormat(d[i].name);
            value = valueFormat(d[i].value, d[i].ratio, d[i].id, d[i].index); // Percentage value
            bgcolor = $$.levelColor ? $$.levelColor(d[i].value) : color(d[i].id);
          }
          let hoverLable;
          let complaintDetails = document.hoverValues; //context of "this" is changed here hence cant access a class variable.
          if (complaintDetails.length > 0) {
            let currComplaint = complaintDetails.filter((item) => item.dataLabel === name)[0];
            console.log("currComplaint" + JSON.stringify(currComplaint));
            console.log("complaintDetails" + JSON.stringify(complaintDetails));
            hoverLable = currComplaint.hoverdataLabel;
            let htmlContent = "<div class='slds-var-p-around_small tooltip-pb-box'><b style='font-weight:16px;width:100%;text-align:center;'>" + name + " : " + value + "</b><p class='tooltip-pb-header slds-m-top_xx-small'>" + hoverLable + "</p><div class='slds-grid slds-wrap slds-var-p-top_xx-small'>";
            htmlContent += "</div></div>";
            return htmlContent;
          }
        }
      }
    });
    /* APLLY COLORS ON LEGEND DOTS */
    let dots = this.template.querySelectorAll(".color-dots");
    for (let i = 0; i < dots.length; i++) {
      //console.log("inside dots selector"+ this.arrColor[i]);
      dots[i].style.borderColor = this.arrColor[i];
    }
  }
  //destroy the chart once the elemnt is destroyed
  disconnectedCallback() {
    if (this.chart && this.chart !== undefined && this.chart !== null) {
      this.chart.destroy();
    }
  }

  @api
  updateData(newData, widthData, outerData) {
    this.mapOfValues = [];
    this.arrColor = [];
    this.arrKeys = [];
    this.chartData = newData;
    document.hoverValues = newData;
    this.arcWidth = widthData;
    this.outerWidth = outerData;
    for (let i = 0; i < this.chartData.length; i++) {
      let tempData = [this.chartData[i]['dataLabel'], this.chartData[i]['data']];
      console.log('tempData ' + tempData);
      this.mapOfValues.push(tempData);
      console.log('this.mapOfValues ' + this.mapOfValues);
      this.arrColor.push(this.chartData[i]['color']);
      this.arrKeys.push(this.chartData[i]['dataLabel']);
      console.log('this.arrKeys' + this.arrKeys);
      console.log('this.arrColor' + this.arrColor);
    }
    this.drawChart();
  }

  @api
  updatePosition(position) {
    let legendpos = position;
    if (legendpos == 'Top') {
      this.legend.Top = true;
      this.legend.Bottom = false;
      this.legend.Left = false;
      this.legend.Right = false;
    } else if (legendpos == 'Bottom') {
      this.legend.Top = false;
      this.legend.Bottom = true;
      this.legend.Left = false;
      this.legend.Right = false;
    } else if (legendpos == 'Left') {
      this.legend.Top = false;
      this.legend.Bottom = false;
      this.legend.Left = true;
      this.legend.Right = false;
    } else if (legendpos == 'Right') {
      this.legend.Top = false;
      this.legend.Bottom = false;
      this.legend.Left = false;
      this.legend.Right = true;
    }
  }
  }