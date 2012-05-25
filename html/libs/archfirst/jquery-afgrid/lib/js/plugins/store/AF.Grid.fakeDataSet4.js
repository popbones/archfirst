/**
 * Copyright 2011 Archfirst
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @author Manish Shanker
 */

 (function ($) {

    AF.Grid.fakeDataSet4 = (function () {
        function getColumns() {
            return [{
                label: "Title Name",
                id: "colTitleName",
                width: 150,
                filterData: "",
                groupBy: true
            }, {
                label: "Title Released",
                id: "colTitleReleased",
                width: 80,
                filterData: "",
                groupBy: true           
            }, {
                label: "Artist Name",
                id: "colName",
                width: 150,
                filterData: "",
                groupBy: true
            }, {
                label: "Born",
                id: "colBorn",
                width: 100,
                renderer: "SYSTEM_DATE",
                filterData: "DATERANGE",
                groupBy: true
            }, {
                label: "Died",
                id: "colDied",
                renderer: "SYSTEM_DATE",
                width: 100,
                filterData: "DATERANGE",
                groupBy: true
            }, {
                label: "Genre",
                id: "colGenre",
                width: 150,
                groupBy: true,
                filterData: AF.Grid.FakeLocalStore.getFilterData(5, rows)
            }];
        }
                
        var rows = [{"id":1,"data":["Billie Jean","1983","Michael Jackson","1958-08-29","2009-06-25","Pop"]},{"id":2,"data":["Beat It","1983","Michael Jackson","1958-08-29","2009-06-25","Pop"]},{"id":3,"data":["Thriller","1984","Michael Jackson","1958-08-29","2009-06-25","Pop"]},{"id":4,"data":["Bad","1987","Michael Jackson","1958-08-29","2009-06-25","Pop"]},{"id":5,"data":["I Just Can't Stop Loving You","1987","Michael Jackson","1958-08-29","2009-06-25","Pop"]},{"id":6,"data":["Man in the Mirror","1987","Michael Jackson","1958-08-29","2009-06-25","Pop"]},{"id":7,"data":["Black or White","1991","Michael Jackson","1958-08-29","2009-06-25","Pop"]},{"id":8,"data":["Please Mister Postman","1963","John Lennon","1940-10-09","1980-12-08","Rock"]},{"id":9,"data":["Ticket to Ride","1965","John Lennon","1940-10-09","1980-12-08","Rock"]},{"id":10,"data":["Come Together","1969","John Lennon","1940-10-09","1980-12-08","Rock"]},{"id":11,"data":["All My Loving","1963","Paul McCartney","1942-06-18","-","Rock"]},{"id":12,"data":["Can't Buy Me Love","1964","Paul McCartney","1942-06-18","-","Rock"]},{"id":13,"data":["Yesterday","1965","Paul McCartney","1942-06-18","-","Rock"]},{"id":14,"data":["Ob-La-Di, Ob-La-Da","1968","Paul McCartney","1942-06-18","-","Rock"]},{"id":15,"data":["Let It Be","1970","Paul McCartney","1942-06-18","-","Rock"]},{"id":16,"data":["Get Back","1970","Paul McCartney","1942-06-18","-","Rock"]},{"id":17,"data":["Superstition","1972","Stevie Wonder","1950-05-13","-","Pop"]},{"id":18,"data":["Ebony and Ivory","1982","Stevie Wonder","1950-05-13","-","Pop"]},{"id":19,"data":["I Just Called to Say I Love You","1984","Stevie Wonder","1950-05-13","-","Pop"]},{"id":20,"data":["Love Me Tender","1956","Elvis Presley","1935-01-08","1977-08-16","Rock and Roll"]},{"id":21,"data":["Heartbreak Hotel","1956","Elvis Presley","1935-01-08","1977-08-16","Rock and Roll"]},{"id":22,"data":["All Shook Up","1957","Elvis Presley","1935-01-08","1977-08-16","Rock and Roll"]},{"id":23,"data":["Are You Lonesome Tonight?","1960","Elvis Presley","1935-01-08","1977-08-16","Rock and Roll"]},{"id":24,"data":["The Power of Love","1993","Celine Dion","1968-03-30","-","Pop"]},{"id":25,"data":["Because You Loved Me","1996","Celine Dion","1968-03-30","-","Pop"]},{"id":26,"data":["It's All Coming Back to Me Now","1996","Celine Dion","1968-03-30","-","Pop"]},{"id":27,"data":["My Heart Will Go On","1997","Celine Dion","1968-03-30","-","Pop"]},{"id":28,"data":["Rock n' Roll Madonna","1970","Elton John","1947-03-25","-","Rock"]},{"id":29,"data":["Victim of Love","1979","Elton John","1947-03-25","-","Rock"]},{"id":30,"data":["Like a Virgin","1984","Madonna","1958-08-16","-","Pop"]},{"id":31,"data":["Papa Don't Preach","1986","Madonna","1958-08-16","-","Pop"]},{"id":32,"data":["La Isla Bonita","1986","Madonna","1958-08-16","-","Pop"]},{"id":33,"data":["Paint It Black","1966","Mick Jagger","1943-07-26","-","Rock"]},{"id":34,"data":["(I Can't Get No) Satisfaction","1965","Mick Jagger","1943-07-26","-","Rock"]},{"id":35,"data":["-","-","Barbra Streisand","1942-04-24","-","Pop"]},{"id":36,"data":["-","-","Barbra Streisand","1942-04-24","-","Pop"]},{"id":37,"data":["Born in the U.S.A.","1984","Bruce Springsteen","1949-09-23","-","Rock"]},{"id":38,"data":["Dancing in the Dark","1984","Bruce Springsteen","1949-09-23","-","Rock"]},{"id":39,"data":["We've Only Just Begun","1970","Karen Carpenter","1950-03-02","-","Pop"]},{"id":40,"data":["Superstar","1971","Karen Carpenter","1950-03-02","-","Pop"]},{"id":41,"data":["Rainy Days And Mondays","1971","Karen Carpenter","1950-03-02","-","Pop"]},{"id":42,"data":["Top Of The World","1973","Karen Carpenter","1950-03-02","-","Pop"]},{"id":43,"data":["-","-","Frank Sinatra","1915-12-12","1998-05-14","Pop"]},{"id":44,"data":["-","-","Frank Sinatra","1915-12-12","1998-05-14","Pop"]},{"id":45,"data":["Lady","1980","Kenny Rogers","1938-08-21","-","Country"]},{"id":46,"data":["Islands in the Stream","1983","Kenny Rogers","1938-08-21","-","Country"]},{"id":47,"data":["Endless Love","1981","Lionel Richie","1949-06-20","-","Soul"]},{"id":48,"data":["All Night Long","1983","Lionel Richie","1949-06-20","-","Soul"]},{"id":49,"data":["Hello","1984","Lionel Richie","1949-06-20","-","Soul"]},{"id":50,"data":["Say You, Say Me","1985","Lionel Richie","1949-06-20","-","Soul"]}];

        return {
            columns: getColumns(),
            rows: rows
        };

    }());

}(jQuery));
 
 
 
 
  
  
 /*   
        
        var data = {
  "Artists": {
    "Artist": [
      {
        "Name": "Michael Jackson",
        "Genre": "Pop",
        "Born": "1958-08-29",
        "Died": "2009-06-25",
        "Title": [
          {
            "Name": "Billie Jean",
            "Released": "1983"
          },
          {
            "Name": "Beat It",
            "Released": "1983"
          },
          {
            "Name": "Thriller",
            "Released": "1984"
          },
          {
            "Name": "Bad",
            "Released": "1987"
          },
          {
            "Name": "I Just Can't Stop Loving You",
            "Released": "1987"
          },
          {
            "Name": "Man in the Mirror",
            "Released": "1987"
          },
          {
            "Name": "Black or White",
            "Released": "1991"
          }
        ]
      },
      {
        "Name": "John Lennon",
        "Genre": "Rock",
        "Born": "1940-10-09",
        "Died": "1980-12-08",
        "Title": [
          {
            "Name": "Please Mister Postman",
            "Released": "1963"
          },
          {
            "Name": "Ticket to Ride",
            "Released": "1965"
          },
          {
            "Name": "Come Together",
            "Released": "1969"
          }
        ]
      },
      {
        "Name": "Paul McCartney",
        "Genre": "Rock",
        "Born": "1942-06-18",
        "Title": [
          {
            "Name": "All My Loving",
            "Released": "1963"
          },
          {
            "Name": "Can't Buy Me Love",
            "Released": "1964"
          },
          {
            "Name": "Yesterday",
            "Released": "1965"
          },
          {
            "Name": "Ob-La-Di, Ob-La-Da",
            "Released": "1968"
          },
          {
            "Name": "Let It Be",
            "Released": "1970"
          },
          {
            "Name": "Get Back",
            "Released": "1970"
          }
        ]
      },
      {
        "Name": "Stevie Wonder",
        "Genre": "Pop",
        "Born": "1950-05-13",
        "Title": [
          {
            "Name": "Superstition",
            "Released": "1972"
          },
          {
            "Name": "Ebony and Ivory",
            "Released": "1982"
          },
          {
            "Name": "I Just Called to Say I Love You",
            "Released": "1984"
          }
        ]
      },
      {
        "Name": "Elvis Presley",
        "Genre": "Rock and Roll",
        "Born": "1935-01-08",
        "Died": "1977-08-16",
        "Title": [
          {
            "Name": "Love Me Tender",
            "Released": "1956"
          },
          {
            "Name": "Heartbreak Hotel",
            "Released": "1956"
          },
          {
            "Name": "All Shook Up",
            "Released": "1957"
          },
          {
            "Name": "Are You Lonesome Tonight?",
            "Released": "1960"
          }
        ]
      },
      {
        "Name": "Celine Dion",
        "Genre": "Pop",
        "Born": "1968-03-30",
        "Title": [
          {
            "Name": "The Power of Love",
            "Released": "1993"
          },
          {
            "Name": "Because You Loved Me",
            "Released": "1996"
          },
          {
            "Name": "It's All Coming Back to Me Now",
            "Released": "1996"
          },
          {
            "Name": "My Heart Will Go On",
            "Released": "1997"
          }
        ]
      },
      {
        "Name": "Elton John",
        "Genre": "Rock",
        "Born": "1947-03-25",
        "Title": [
          {
            "Name": "Rock n' Roll Madonna",
            "Released": "1970"
          },
          {
            "Name": "Victim of Love",
            "Released": "1979"
          }
        ]
      },
      {
        "Name": "Madonna",
        "Genre": "Pop",
        "Born": "1958-08-16",
        "Title": [
          {
            "Name": "Like a Virgin",
            "Released": "1984"
          },
          {
            "Name": "Papa Don't Preach",
            "Released": "1986"
          },
          {
            "Name": "La Isla Bonita",
            "Released": "1986"
          }
        ]
      },
      {
        "Name": "Mick Jagger",
        "Genre": "Rock",
        "Born": "1943-07-26",
        "Title": [
          {
            "Name": "Paint It Black",
            "Released": "1966"
          },
          {
            "Name": "(I Can't Get No) Satisfaction",
            "Released": "1965"
          }
        ]
      },
      {
        "Name": "Barbra Streisand",
        "Genre": "Pop",
        "Born": "1942-04-24",
        "Title": {
          "Name": "Woman in Love",
          "Released": "1980"
        }
      },
      {
        "Name": "Bruce Springsteen",
        "Genre": "Rock",
        "Born": "1949-09-23",
        "Title": [
          {
            "Name": "Born in the U.S.A.",
            "Released": "1984"
          },
          {
            "Name": "Dancing in the Dark",
            "Released": "1984"
          }
        ]
      },
      {
        "Name": "Karen Carpenter",
        "Genre": "Pop",
        "Born": "1950-03-02",
        "Title": [
          {
            "Name": "We've Only Just Begun",
            "Released": "1970"
          },
          {
            "Name": "Superstar",
            "Released": "1971"
          },
          {
            "Name": "Rainy Days And Mondays",
            "Released": "1971"
          },
          {
            "Name": "Top Of The World",
            "Released": "1973"
          }
        ]
      },
      {
        "Name": "Frank Sinatra",
        "Genre": "Pop",
        "Born": "1915-12-12",
        "Died": "1998-05-14",
        "Title": {
          "Name": "Fly Me To The Moon",
          "Released": "1964"
        }
      },
      {
        "Name": "Kenny Rogers",
        "Genre": "Country",
        "Born": "1938-08-21",
        "Title": [
          {
            "Name": "Lady",
            "Released": "1980"
          },
          {
            "Name": "Islands in the Stream",
            "Released": "1983"
          }
        ]
      },
      {
        "Name": "Lionel Richie",
        "Genre": "Soul",
        "Born": "1949-06-20",
        "Title": [
          {
            "Name": "Endless Love",
            "Released": "1981"
          },
          {
            "Name": "All Night Long",
            "Released": "1983"
          },
          {
            "Name": "Hello",
            "Released": "1984"
          },
          {
            "Name": "Say You, Say Me",
            "Released": "1985"
          }
        ]
      }
    ]
  }
};

var rows=[];
var counter=1;
for (var artist in data.Artists.Artist) {
    var aArtist = data.Artists.Artist[artist];
    for (var title in aArtist.Title) {
        var row = []            
        row.push(aArtist.Title[title].Name)
        row.push(aArtist.Title[title].Released)
        row.push(aArtist.Name)
        row.push(aArtist.Born)  
        row.push(aArtist.Died)
        row.push(aArtist.Genre)
        rows.push({id:counter++, data:row});
    }
}
console.log(JSON.stringify(rows))

*/