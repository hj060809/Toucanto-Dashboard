# TODO

## Total
- **FEAT**: ffprobe, ffmpeg 관리를 어떻게 할 것인가?
    * > 외부 라이브러리 사용 => 유지/보수되는가? 안정적인가? 폐기 위험은 없는가?
    * > 직접 file control => 파일 버전 관리는? 메모리? 권한 등  
- **SYS**: utils, dao 정비
    * > utils를 각 기능별로 분리 => 모듈화 => 한 파일로 전부 import 가능하게
- **SYS**: 폴더 구조 정비
    * > 전체 page 폴더 만들기
    * > main page와 main.dart 분리
- **FEAT**: Future.wait을 이용한 load-speed 개선
- **BUG**: Upload - Download 페이지 넘나들 때 에러가 발생함
    * > loading 중 페이지 변경 시 crash 발생
    * > load 취소 기능 필요

## Music Upload
- **FEAT**: 업로드할 대상 음악 체크박스 만들기
- **FEAT**: 삭제시 경고 메시지 출력
- **SYS**: 음악의 duplication이 모든 음악을 반영하게 수정
    * > 매번 Supabase DB 전부 받아와서 처리...?
    * > 그럼 또 cache 처리 해줘야 함