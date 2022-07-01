# GIPHY_Search 
이승재

## 설계
- MVVM + C 아키텍쳐

## 사용 API
- GIPHY API Search Endpoint
  - Gif 검색
  - Sticker 검색

## 구현사항
### 공통
- Animated Image
  - 움직이는 이미지를 구현하기 위해 API에서 제공하는 Mp4 포맷을 사용하였으며, 이를 위해 AVURLAsset 및 AVplayer 사용
  - CollectionView Cell에서 사용될 시 최적화를 위해 셀 Visible 조건에 따라 재생, 멈춤 및 셀 재사용 시 player 제거
- Cache
  - 이미지 및 비디오를 캐싱하는 CacheManager 구현
  - 이미지는 URLCache, 비디오는 NSCache를 사용

### 검색화면
- 키워드 검색
  - 이미지의 Aspect Ratio에 대응하는 Dynamic height CollectionView Layout 구현
- 검색 Scope(Gif/Sticker)
  - 검색 Scope 변경을 통한 요청 Image Type 변경 기능 구현
- Search Query History 저장 기능
  - 코어데이터 사용
  - 검색 히스토리를 컬렉션뷰를 통해 보여주고 

### 상세화면
- Favorites On/off
  - 코어데이터 사용
- Image AspectRatio 적용
