# MoviesApp_Rx
영화 검색 기능을 지원하며, 최신 개봉, 인기 영화 등을 보여주는 영화 추천 앱입니다.

## 홈 탭

### 홈 화면

<div style="width:100; margin:0 auto;">
<img style="width:30%" src="/MoviesApp_Rx/MoviesApp_Rx/Resource/Images/HomeView.png">
<img style="width:30%" src="/MoviesApp_Rx/MoviesApp_Rx/Resource/Images/HomeView2.png">
</div>

- 4개의 섹션
  - Discover : 영화 추천 목록
  - Popular : 인기 영화 목록 (수평 스크롤)
  - Trending : 최근 뜨는 영화 목록
  - Latest : 최신 개봉 영화

<br>

### 상세 화면
<img src="/MoviesApp_Rx/MoviesApp_Rx/Resource/Images/DetailView.png" width="300">

- 영화 소개, 개봉일, 평점 등 영화 상세 정보 제공

<br>

### 즐겨찾기 성공 / 실패

| <img src="/MoviesApp_Rx/MoviesApp_Rx/Resource/Images/StarButtonTapped_success.png" width="300"> | <img src="/MoviesApp_Rx/MoviesApp_Rx/Resource/Images/StarButtonTapped_failure.png" width="300"> |
| :--: | :--: |
| 로그인 상태일 경우 즐겨찾기 기능 제공 | 로그아웃 상태일 경우 즐겨찾기 기능 제한 |

- 로그인 여부에 따라 즐겨찾기 기능 제공
  - 내 정보 화면의 Star 섹션과 연동

<br>

---

## 검색 탭

### 검색 화면

| <img src="/MoviesApp_Rx/MoviesApp_Rx/Resource/Images/SearchView.png" width="300"> | <img src="/MoviesApp_Rx/MoviesApp_Rx/Resource/Images/SearchView_CollectionSection.png" width="300"> |
| :--: | :--: |
| 검색 화면 (영화 섹션) | 검색 화면 (컬렉션 섹션) |

- 검색어를 기반으로 영화 / 컬렉션 리스트를 제공

<br>

### 컬렉션 상세

| <img src="/MoviesApp_Rx/MoviesApp_Rx/Resource/Images/SearchTab_CollectionDetailView.png" width="300"> | <img src="/MoviesApp_Rx/MoviesApp_Rx/Resource/Images/SearchTab_Collection_DetailView.png" width="300"> |
| :--: | :--: |
| 컬렉션 상세 화면 | 영화 상세화면 |

- 검색 화면의 컬렉션 탭 시 해당 컬렉션의 영화 리스트를 제공

<br>

---

## 로그인 탭

| <img src="/MoviesApp_Rx/MoviesApp_Rx/Resource/Images/LoginView.png" width="300"> | <img src="/MoviesApp_Rx/MoviesApp_Rx/Resource/Images/JoinView.png" width="300"> | <img src="/MoviesApp_Rx/MoviesApp_Rx/Resource/Images/JoinViewError.png" width="300"> |
| :--: | :--: | :--: |
| 로그인 화면 | 회원가입 화면 | 빈 텍스트필드 에러 처리 |

- Firebase 로그인/회원가입 기능
- 텍스트 필드 미입력 후 버튼 탭 시 에러 처리 (빨간 시각 효과)

<br>

### 내 정보 화면

| <img src="/MoviesApp_Rx/MoviesApp_Rx/Resource/Images/MyInfoView.png" width="300"> | <img src="/MoviesApp_Rx/MoviesApp_Rx/Resource/Images/Logout.png" width="300"> |
| :--: | :--: |
| 내 정보 | 로그아웃 |

- 3개의 섹션
  - 프로필 섹션
    - 계정 이메일 표시
  - Star 섹션
    - 상세 화면의 Star 버튼과 연동
  - 세팅 섹션
    - 로그아웃 버튼
