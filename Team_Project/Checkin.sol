pragma solidity 0.8.4;

contract CheckIn {
    enum Status {Vacant, Occupied}

    // ======= 변수 =======

    // 주인/손님
    address payable public host;
    address payable public guest;

    // 대여 시작 시간/종료 시간
    uint256 public start_time;
    uint256 public end_time;

    // 대여료
    uint256 public cost;

    // 대여 상태
    Status public status;

    // ======= 생성자 =======
    constructor() {
        host = payable(msg.sender);
        status = Status.Vacant;
    }

    // ======= 제한자 =======

    // 주인만 작동시킬 수 있도록 하는 제한자
    modifier only_host() {
        require(host == msg.sender, "Only host can access.");
        _;
    }

    // 손님만 작동시킬 수 있도록 하는 제한자
    modifier only_guest() {
        require(guest == msg.sender, "Only guest can access.");
        _;
    }

    // 대여 시작 시간이 지나지 않았을 때만 작동시킬 수 있도록 하는 제한자
    modifier not_started() {
        require(block.timestamp < start_time, "Not started.");
        _;
    }

    // 아직 예약되지 않았을 때만 작동시킬 수 있도록 하는 제한자
    modifier not_booked() {
        require(status == Status.Vacant, "Already booked.");
        _;
    }

    // 보낸 이더가 일정 이상일 때만 작동시킬 수 있도록 하는 제한자.
    modifier costs(uint256 _amount) {
        require(msg.value >= _amount, "Not enough Ether provided.");
        _;
    }

    // ======= 함수 =======

    // 예약을 위해 사용하는 함수
    function book(uint256 _start, uint256 _end) public payable not_booked costs(1 ether) {
        require(msg.sender != host);
        cost = msg.value;
        guest = payable(msg.sender);
        start_time = _start;
        end_time = _end;
        status = Status.Occupied;
    }

    // 예약자를 변경하기 위해 사용하는 함수
    function updateAddress(address _address) public only_guest not_started {
        guest = payable(_address);
    }

    // 시작 시간을 변경하기 위해 수행하는 함수
    function updateStartTime(uint256 _start) public only_guest not_started {
        require(block.timestamp < _start);
        start_time = _start;
    }

    // 종료 시간을 변경하기 위해 사용하는 함수
    function updateEndTime(uint256 _end) public only_guest not_started {
        require(start_time < _end);
        end_time = _end;
    }

    // 예약을 취소하기 위해 수행하는 함수
    function cancal() public only_guest not_started {
        guest.transfer(cost);

        delete guest;
        delete start_time;
        delete end_time;
        delete cost;
        status = Status.Vacant;
    }

    // 숙박 시간이 종료된 이후 정산을 위해 수행하는 함수
    function settlement() public only_host {
        // 이 부분은 예약 기간이 끝났는지 확인하는 코드입니다.
        // 원활한 시연을 위해 삭제했습니다.
        // require(block.timestamp >= end_time, "Reservation time is not ended yet.");

        host.transfer(cost);
        delete guest;
        delete start_time;
        delete end_time;
        delete cost;
        status = Status.Vacant;
    }

    // 시작시간과 종료시간을 조회하는 함수
    function lookup() public view only_guest returns (uint256, uint256) {
        return (start_time, end_time);
    }

    // 객실이 예약되었는지 확인하는 함수
    function isOccupated() public view returns (bool) {
        return status == Status.Occupied;
    }
}
