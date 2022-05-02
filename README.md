# PhotoBookApp

## Core Data Notes

###### A trick about fetching from core data

```
let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gallery")
fetchRequest.returnsObjectsAsFaults = false
```

if you need to access the objects immediately after the fetch request, it's more efficient to set **returnsObjectsAsFaults** to **false**. Because it'll load everything immediately without needing to retrieve the data from the row cache.

But if you don't need the data immediately, it's more efficient to set **returnsObjectsAsFaults** to **true**. So it loads from the row cache only when needed.


## Why Core Data

- Apple cihazlar için en sorunsuz çalışan veritabanı
- Başka 3. parti kütüphalere ihityacımız olmaz
- Kullanıcı deneyimi çok iyi

Projeyi oluştururken core data yı seçmeyi unutmayın :)  (Use Core Data) 

- .xcdatamodel dosyası oluşur, bu bizim veri modelimizi oluşturuyor.
