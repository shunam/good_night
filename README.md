
# README

* Ruby version: 3.2.1

* System dependencies:
  * SQLite

* Configuration
  * bundle install

* Database creation
  * rake db:setup

* How to run the test suite
  * rspec
  * see code coverage if folder coverage after you run rspec. (100% coverage)

* All json responses is compliant with https://jsonapi.org/

# API DOC

## GET /v1/users/:user_id/clock_ins OR /v1/users/:user_id/clock_outs
| Parameter | Format | Required | Description |
| ----- | ----- | ----- | ----- |
| page | number | optional | if not fill, it will always get page 1. 10 data each page |

### Response 200
```sh
{
  "data": [
    {
      "id": "11",
      "type": "clock_time",
      "attributes": {
        "clock_in": "2023-03-07T04:42:30.445Z",
        "clock_out": "2023-03-07T04:42:31.445Z",
        "sleep_length": 1
      },
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      }
    },
    {
      "id": "12",
      "type": "clock_time",
      "attributes": {
        "clock_in": "2023-03-07T04:42:31.445Z",
        "clock_out": "2023-03-07T04:42:32.445Z",
        "sleep_length": 1
      },
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      }
    },
    {
      "id": "13",
      "type": "clock_time",
      "attributes": {
        "clock_in": "2023-03-07T04:42:32.445Z",
        "clock_out": "2023-03-07T04:42:33.445Z",
        "sleep_length": 1
      },
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      }
    },
    {
      "id": "14",
      "type": "clock_time",
      "attributes": {
        "clock_in": "2023-03-07T04:42:33.445Z",
        "clock_out": "2023-03-07T04:42:34.445Z",
        "sleep_length": 1
      },
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      }
    },
    {
      "id": "15",
      "type": "clock_time",
      "attributes": {
        "clock_in": "2023-03-07T04:42:34.445Z",
        "clock_out": "2023-03-07T04:42:35.445Z",
        "sleep_length": 1
      },
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      }
    },
    {
      "id": "16",
      "type": "clock_time",
      "attributes": {
        "clock_in": "2023-03-07T04:42:35.445Z",
        "clock_out": "2023-03-07T04:42:36.445Z",
        "sleep_length": 1
      },
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      }
    },
    {
      "id": "17",
      "type": "clock_time",
      "attributes": {
        "clock_in": "2023-03-07T04:42:36.445Z",
        "clock_out": "2023-03-07T04:42:37.445Z",
        "sleep_length": 1
      },
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      }
    },
    {
      "id": "18",
      "type": "clock_time",
      "attributes": {
        "clock_in": "2023-03-07T04:42:37.445Z",
        "clock_out": "2023-03-07T04:42:38.445Z",
        "sleep_length": 1
      },
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      }
    },
    {
      "id": "19",
      "type": "clock_time",
      "attributes": {
        "clock_in": "2023-03-07T04:42:38.445Z",
        "clock_out": "2023-03-07T04:42:39.445Z",
        "sleep_length": 1
      },
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      }
    },
    {
      "id": "20",
      "type": "clock_time",
      "attributes": {
        "clock_in": "2023-03-07T04:42:39.445Z",
        "clock_out": "2023-03-07T04:42:40.445Z",
        "sleep_length": 1
      },
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "user"
          }
        }
      }
    }
  ],
  "links": {
    "prev": "http://www.example.com/v1/users/1/clock_ins?page=1",
    "next": "http://www.example.com/v1/users/1/clock_ins?page=3"
  }
}
```

### Response 404
```sh
{
  "errors": {
    "code": 404,
    "details": [
      "Couldn't find User with 'id'=0" # if user_id not exist in DB
    ]
  }
}
```

## POST /v1/users/:user_id/clock_ins
| Parameter | Format | Required | Description |
| ----- | ----- | ----- | ----- |
| clock_in | %Y-%m-%d %H:%M:%S | true | UTC time when user clock in |

### Response 200
```sh
{
  "data": {
    "id": "1",
    "type": "clock_time",
    "attributes": {
      "clock_in": "2023-03-07T11:50:15.000Z",
      "clock_out": null,
      "sleep_length": null
    },
    "relationships": {
      "user": {
        "data": {
          "id": "1",
          "type": "user"
        }
      }
    }
  }
}
```

### Response 404
```sh
{
  "errors": {
    "code": 404,
    "details": [
      "Couldn't find User with 'id'=0" # if user_id not exist in DB
    ]
  }
}
```

### Response 400
```sh
{
  "errors": {
    "code": 400,
    "details": [
      "Clock in can't be blank" # if params clock_in is nil
    ]
  }
}
```

## PATCH /v1/users/:user_id/clock_outs
| Parameter | Format | Required | Description |
| ----- | ----- | ----- | ----- |
| clock_out | %Y-%m-%d %H:%M:%S | true / optional | UTC time when user clock out |
| id | number | true / optional | clock time ID or clock_out must be filled |

### Response 200
```sh
{
  "data": {
    "id": "2",
    "type": "clock_time",
    "attributes": {
      "clock_in": "2023-03-06T14:50:30.000Z",
      "clock_out": "2023-03-07T08:50:40.000Z",
      "sleep_length": 64810
    },
    "relationships": {
      "user": {
        "data": {
          "id": "1",
          "type": "user"
        }
      }
    }
  }
}
```

### Response 404
```sh
{
  "errors": {
    "code": 404,
    "details": [
      "Couldn't find User with 'id'=0"
    ]
  }
}
```

### Response 400
```sh
{
  "errors": {
    "code": 400,
    "details": [
      "ID or clock out must not be empty", # if params id and clock out is empty
      "Clock out already exist" # If you try to update clocktime that already has clock_out value.
    ]
  }
}
```

## POST /v1/users/:user_id/friendships/follow
| Parameter | Format | Required | Description |
| ----- | ----- | ----- | ----- |
| friend_id | number | true | user_id from other users |

### Response 200
```sh
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "name": "Hendrik"
    },
    "relationships": {
      "friends": {
        "data": [
          {
            "id": "2",
            "type": "user"
          }
        ]
      }
    }
  }
}
```

### Response 404
```sh
{
  "errors": {
    "code": 404,
    "details": [
      "Couldn't find User without an ID", # if params friend_id or user_id is nil
      "Couldn't find User with 'id'=0" # if user_id or friend_id is not exist in DB
    ]
  }
}
```

## DELETE /v1/users/:user_id/friendships/unfollow
| Parameter | Format | Required | Description |
| ----- | ----- | ----- | ----- |
| friend_id | number | true | user_id from other users |

### Response 200
```sh
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "name": "Hendrik"
    },
    "relationships": {
      "friends": {
        "data": []
      }
    }
  }
}
```

### Response 404
```sh
{
  "errors": {
    "code": 404,
    "details": [
      "Couldn't find User without an ID", # if params user_id or friend_id is nil
      "Couldn't find User with 'id'=0", # if user_id or friend_id is not exist in DB
      "Friendship not found" # if relation not exist in DB
    ]
  }
}
```

## GET /v1/users/:user_id/sleep_records
| Parameter | Format | Required | Description |
| ----- | ----- | ----- | ----- |
| page | number | optional | if not fill, it will always get page 1. 10 data each page |

### Response 200
```sh
{
  "data": [
    {
      "id": null,
      "type": "sleep_record",
      "attributes": {
        "humanize_total_sleep_length": "24 hours 15 minutes 10 seconds"
      },
      "relationships": {
        "user": {
          "data": {
            "id": "5",
            "type": "user"
          }
        }
      }
    },
    {
      "id": null,
      "type": "sleep_record",
      "attributes": {
        "humanize_total_sleep_length": "10 hours 0 minutes 0 seconds"
      },
      "relationships": {
        "user": {
          "data": {
            "id": "4",
            "type": "user"
          }
        }
      }
    },
    {
      "id": null,
      "type": "sleep_record",
      "attributes": {
        "humanize_total_sleep_length": "8 hours 0 minutes 0 seconds"
      },
      "relationships": {
        "user": {
          "data": {
            "id": "2",
            "type": "user"
          }
        }
      }
    },
    {
      "id": null,
      "type": "sleep_record",
      "attributes": {
        "humanize_total_sleep_length": "4 hours 0 minutes 0 seconds"
      },
      "relationships": {
        "user": {
          "data": {
            "id": "3",
            "type": "user"
          }
        }
      }
    }
  ],
  "links": {
    "next": "http://www.example.com/v1/users/1/sleep_records?page=2"
  }
}
```

### Response 404
```sh
{
  "errors": {
    "code": 404,
    "details": [
      "Couldn't find User without an ID" # if params user_id is nil
    ]
  }
}
```
